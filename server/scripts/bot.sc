// Bots Carpet encadrés : 1 bot par joueur, arrêté 30 min après le départ de son propriétaire,
// XP récupérée par le propriétaire seul avec /bot xp (pas de mort, donc pas de tombe).
// Les joueurs passent par /bot ; /player reste réservé aux ops (règle Carpet commandPlayer).

global_offline_limit_ms = 30 * 60 * 1000;
global_check_period_ticks = 400;
// Recharge complète d'une épée (vitesse 1.6 = 12.5 ticks) : sans elle, pas de balayage.
global_attack_interval_ticks = 13;

__config() -> {
    'scope' -> 'global',
    'stay_loaded' -> true,
    'command_permission' -> 'players',
    'commands' -> {
        '' -> 'cmd_status',
        'spawn' -> 'cmd_spawn',
        'attack' -> 'cmd_attack',
        'stop' -> 'cmd_stop',
        'xp' -> 'cmd_xp',
    },
};

// État sauvegardé dans world/scripts/bot.data.nbt : survit aux redémarrages.
global_owner_bots = {};    // uuid propriétaire -> nom de son bot
global_banked_xp = {};     // uuid propriétaire -> points d'XP en attente
global_owner_left_at = {}; // uuid propriétaire -> unix_time() de sa déconnexion (bot actif)
// Bots morts entre leur mort et leur déconnexion : leur XP est déjà dans la tombe.
global_dead_bots = {};
// uuid propriétaire -> unix_time() du /bot spawn : Carpet connecte le bot en différé,
// un 2e spawn entre-temps crée un doublon (même UUID).
global_spawn_pending = {};
global_spawn_timeout_ms = 10 * 1000;

_map_or_empty(value) -> if (value == null, {}, value);

_load() -> (
    data = load_app_data();
    if (data == null, return());
    state = parse_nbt(data);
    global_owner_bots = _map_or_empty(state:'owner_bots');
    global_banked_xp = _map_or_empty(state:'banked_xp');
    global_owner_left_at = _map_or_empty(state:'owner_left_at');
);

_save() -> store_app_data(encode_nbt({
    'owner_bots' -> global_owner_bots,
    'banked_xp' -> global_banked_xp,
    'owner_left_at' -> global_owner_left_at,
}));

// Même calcul que vanilla 1.21.1 et Universal Graves (percent_points) : niveau + barre, en points.
_xp_needed(level) -> if (level >= 30, 112 + (level - 30) * 9, level >= 15, 37 + (level - 15) * 5, 7 + level * 2);

_xp_for_level(level) -> if (
    level <= 16, level * level + 6 * level,
    level <= 31, 2.5 * level * level - 40.5 * level + 360,
    4.5 * level * level - 162.5 * level + 2220
);

_xp_points(p) -> (
    level = p ~ 'xp_level';
    floor(_xp_for_level(level) + p ~ 'xp_progress' * _xp_needed(level))
);

_banked(uuid) -> if (has(global_banked_xp, uuid), global_banked_xp:uuid, 0);

// Vide l'XP du bot dans la réserve de son propriétaire.
_bank_bot_xp(owner_uuid, bot) -> (
    points = _xp_points(bot);
    // Niveau < 0 : vanilla remet niveau, barre et total à 0 (Player.giveExperienceLevels).
    modify(bot, 'xp_level', -1);
    if (points > 0, put(global_banked_xp, owner_uuid, _banked(owner_uuid) + points));
    points
);

// Pseudo MC : [A-Za-z0-9_], 16 caractères max ; le préfixe est tronqué avec le reste.
_bot_name(owner) -> (
    name = 'bot_' + (owner ~ 'name');
    if (length(name) > 16, slice(name, 0, 16), name)
);

_online_bot(owner_uuid) -> (
    name = global_owner_bots:owner_uuid;
    if (name == null, return(null));
    bot = player(name);
    if (bot != null && bot ~ 'player_type' == 'fake', bot, null)
);

// Sans casse : Carpet reprend la casse d'un vrai compte Mojang homonyme (bot_Alice → bot_alice).
_owner_of(bot_name) -> first(keys(global_owner_bots), lower(global_owner_bots:_) == lower(bot_name));

cmd_status() -> (
    p = player();
    uuid = p ~ 'uuid';
    bot = _online_bot(uuid);
    pending = _banked(uuid) + if (bot != null, _xp_points(bot), 0);
    if (bot != null,
        print('Ton bot ' + (bot ~ 'name') + ' est actif.'),
        print('Pas de bot actif. /bot spawn le fait apparaître à ta place, regard compris.')
    );
    print('XP à récupérer : ' + pending + ' points (/bot xp).');
);

cmd_spawn() -> (
    p = player();
    uuid = p ~ 'uuid';
    owner = p ~ 'name';
    name = _bot_name(p);
    if (_online_bot(uuid) != null,
        print('Ton bot ' + name + ' est déjà là. /bot stop pour l’arrêter.');
        return()
    );
    if (has(global_spawn_pending, uuid) && unix_time() - global_spawn_pending:uuid < global_spawn_timeout_ms,
        print('Ton bot arrive, patiente quelques secondes.');
        return()
    );
    if (player(name) != null,
        print('Le pseudo ' + name + ' est déjà utilisé par un joueur connecté.');
        return()
    );
    // execute at : le bot reprend position, regard et dimension du propriétaire.
    [count, output, error] = run('execute at ' + owner + ' run player ' + name + ' spawn');
    if (error != null,
        print('Échec : ' + error);
        return()
    );
    delete(global_dead_bots, lower(name));
    put(global_spawn_pending, uuid, unix_time());
    put(global_owner_bots, uuid, name);
    _save();
    logger('info', '[bot] ' + owner + ' a fait apparaître ' + name);
    print('Bot ' + name + ' créé. Donne-lui une épée (jette-la à ses pieds) puis /bot attack.');
);

cmd_attack() -> (
    bot = _online_bot(player() ~ 'uuid');
    if (bot == null,
        print('Pas de bot actif. /bot spawn d’abord.');
        return()
    );
    run('player ' + (bot ~ 'name') + ' attack interval ' + global_attack_interval_ticks);
    print((bot ~ 'name') + ' attaque en continu (coup chargé, balayage actif).');
);

cmd_stop() -> (
    bot = _online_bot(player() ~ 'uuid');
    if (bot == null,
        print('Pas de bot actif.');
        return()
    );
    // Déconnexion, pas une mort : l'XP part dans la réserve via __on_player_disconnects.
    run('player ' + (bot ~ 'name') + ' kill');
    print('Bot arrêté. Son XP t’attend : /bot xp.');
);

cmd_xp() -> (
    p = player();
    uuid = p ~ 'uuid';
    bot = _online_bot(uuid);
    if (bot != null, _bank_bot_xp(uuid, bot));
    points = _banked(uuid);
    delete(global_banked_xp, uuid);
    _save();
    if (points <= 0,
        print('Rien à récupérer.');
        return()
    );
    modify(p, 'add_xp', points);
    logger('info', '[bot] ' + (p ~ 'name') + ' a récupéré ' + points + ' points d’XP');
    print('+' + points + ' points d’XP récupérés.');
);

__on_player_connects(player) -> (
    bot_owner = _owner_of(player ~ 'name');
    if (bot_owner != null, delete(global_spawn_pending, bot_owner));
    uuid = player ~ 'uuid';
    if (has(global_owner_left_at, uuid),
        delete(global_owner_left_at, uuid);
        _save()
    );
);

__on_player_disconnects(player, reason) -> (
    name = player ~ 'name';
    owner_uuid = _owner_of(name);
    if (owner_uuid != null && player ~ 'player_type' == 'fake',
        // Bot parti (arrêt, délai) : son XP attend son propriétaire.
        // Bot mort : la tombe a déjà pris son XP ; Carpet déconnecte au lieu de faire réapparaître,
        // donc sans remise à zéro le bot la retrouverait à son prochain spawn (XP dupliquée).
        // Arrêt du serveur : pas d'événement, l'XP reste dans la sauvegarde du bot.
        if (has(global_dead_bots, lower(name)),
            delete(global_dead_bots, lower(name));
            modify(player, 'xp_level', -1),
            points = _bank_bot_xp(owner_uuid, player);
            logger('info', '[bot] ' + name + ' déconnecté, ' + points + ' points d’XP mis de côté')
        );
        _save(),
        _online_bot(player ~ 'uuid') != null,
        put(global_owner_left_at, player ~ 'uuid', unix_time());
        _save()
    );
);

__on_player_dies(player) -> (
    name = player ~ 'name';
    if (_owner_of(name) != null && player ~ 'player_type' == 'fake', put(global_dead_bots, lower(name), true));
);

_check_offline_owners() -> (
    now = unix_time();
    for (keys(global_owner_left_at),
        uuid = _;
        if (now - global_owner_left_at:uuid >= global_offline_limit_ms,
            bot = _online_bot(uuid);
            if (bot != null,
                logger('info', '[bot] ' + (bot ~ 'name') + ' arrêté : propriétaire absent depuis 30 min');
                run('player ' + (bot ~ 'name') + ' kill')
            );
            delete(global_owner_left_at, uuid);
            _save()
        )
    );
    schedule(global_check_period_ticks, '_check_offline_owners');
);

_load();
schedule(global_check_period_ticks, '_check_offline_owners');
