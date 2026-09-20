#!/usr/bin/env python3
"""Genere les chapitres SNBT du livre de quetes FTB Quests (BahBeuh).

Ids/structures/biomes/dimensions verifies dans les jars de server/mods le 2026-09-20.
Tache = type FTBQ ; chaque quete diffuse les coordonnees du joueur a tout le monde
(recompense 'command' + substitutions {x} {y} {z} supportees par CommandReward).

Usage : python3 quests/generate.py server/world/ftbquests/quests/chapters
ATTENTION : ecrase les fichiers du dossier. Des la premiere edition en jeu
(mode edition FTBQ), le SNBT du monde devient la source de verite, pas ce script."""
import pathlib, sys

OUT = pathlib.Path(sys.argv[1])
_n = [0]


def nid():
    _n[0] += 1
    return f"{0x5A00000000000000 + _n[0]:016X}"


def esc(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


def broadcast(label):
    """tellraw a tout le serveur : qui a trouve quoi, et ou."""
    payload = (
        '[{"text":"\\u26f3 ","color":"gold"},{"selector":"@p","color":"white"},'
        f'{{"text":" a trouve : {label} ","color":"gold"}},'
        '{"text":"[{x} {y} {z}]","color":"yellow"}]'
    )
    return {"type": "command", "command": "/tellraw @a " + payload,
            "elevate_perms": True, "silent": True}


def quest(title, task, desc, xp=100, subtitle=None, deps=None, hidden=False,
          rewards=None, no_broadcast=False):
    return {"title": title, "task": task, "desc": desc, "xp": xp,
            "subtitle": subtitle, "deps": deps or [], "hidden": hidden,
            "rewards": rewards or [], "no_broadcast": no_broadcast}


def t_struct(s):
    return {"type": "structure", "structure": s}


def t_biome(b):
    return {"type": "biome", "biome": b}


def t_dim(d):
    return {"type": "dimension", "dim": d}


def t_kill(e, n=1):
    return {"type": "kill", "entity": e, "value": n}


def t_item(i):
    return {"type": "item", "item": i, "count": 1}


def t_check():
    return {"type": "checkmark", "title": "Compris"}


CHAPTERS = [
 dict(file="01_autour_du_camp", title="Autour du camp", icon="minecraft:compass",
      subtitle="A moins de 2000 blocs : de quoi partir sans preparer d'expedition",
      quests=[
   quest("Le carnet d'exploration", t_check(),
         ["Ce livre liste ce qu'il y a a voir sur le serveur.",
          "Il dit &e quoi&r chercher ; les deux boussoles disent &eou&r est le plus proche.",
          "Chacun coche ses propres decouvertes. Quand l'un de vous trouve quelque chose,",
          "ses coordonnees s'affichent dans le chat : les autres peuvent y aller."],
         xp=50, subtitle="Commence ici",
         rewards=[{"type": "item", "item": "explorerscompass:explorerscompass", "count": 1},
                  {"type": "item", "item": "naturescompass:naturescompass", "count": 1}],
         no_broadcast=True),
   quest("Un village habite", t_struct("#minecraft:village"),
         ["Chaque biome a son style de village (ChoiceTheorem + Towns and Towers).",
          "Un bon village = commerces, lit de secours, et souvent un tableau de primes."],
         subtitle="N'importe quel village"),
   quest("Un avant-poste pillard", t_struct("#minecraft:pillager_outpost"),
         ["Ils varient aussi selon le biome. Attention aux capitaines."]),
   quest("La taverne du coin", t_struct("explorify:tavern"),
         ["Petite batisse isolee, facile a rater."]),
   quest("Un campement abandonne", t_struct("structory:abandoned_camp"),
         ["Quelqu'un est passe la avant vous. Il n'est pas reste."]),
   quest("Une tour de guet", t_struct("structory_towers:pillager_lookout"),
         ["Bon point de repere pour cartographier les environs."]),
   quest("Planter une waystone", t_item("waystones:waystone"),
         ["Le reseau de waystones, c'est votre metro.",
          "Une par grande decouverte et l'exploration coute beaucoup moins cher."],
         xp=150, no_broadcast=True),
   quest("Prendre une prime", t_item("bountiful:bountyboard"),
         ["Les tableaux de primes des villages donnent des missions contre recompense.",
          "De quoi se fixer un objectif quand on ne sait pas quoi faire."],
         no_broadcast=True),
   quest("Un cimetiere oublie", t_struct("structory:graveyard"),
         ["Rare, et rarement vide."], deps=["Un campement abandonne"], hidden=True),
      ]),
 dict(file="02_sous_vos_pieds", title="Sous vos pieds", icon="minecraft:torch",
      subtitle="Le sous-sol du serveur n'est pas celui du vanilla",
      quests=[
   quest("Une mine abandonnee", t_struct("#bettermineshafts:better_mineshafts"),
         ["YUNG's remplace les mines vanilla : plus grandes, plus dangereuses, mieux remplies."]),
   quest("Un donjon", t_struct("#betterdungeons:better_dungeons"),
         ["Zombie, squelette ou araignee : trois donjons differents selon l'habitant."]),
   quest("Une cabane engloutie", t_struct("terralith:underground/oak_cabin"),
         ["Quelqu'un a construit ici, sous terre, tres loin de la lumiere."]),
   quest("Une tour enfouie", t_struct("terralith:underground/sunken_tower"),
         ["Elle depassait peut-etre du sol, avant."]),
   quest("Le stronghold", t_struct("#betterstrongholds:better_strongholds"),
         ["Refait par YUNG's : bien plus grand, et le portail est mieux garde."],
         xp=200),
   quest("Grottes de feu glace", t_biome("terralith:cave/frostfire_caves"),
         ["Un des 11 biomes de grotte ajoutes par Terralith. Glace et feu dans la meme salle."]),
      ]),
 dict(file="03_expeditions", title="Expeditions", icon="minecraft:filled_map",
      subtitle="Ca se prepare : vivres, lit, et de quoi rentrer",
      quests=[
   quest("Un pub au fond des bois", t_struct("dungeons_arise:greenwood_pub"),
         ["Dungeons and Taverns : une auberge perdue, habitee."]),
   quest("Le fort des illagers", t_struct("dungeons_arise:illager_fort"),
         ["Gros morceau. Pas a faire seul."], xp=200),
   quest("La tour de l'illusionniste", t_struct("illagerinvasion:illusioner_tower"),
         ["Illager Invasion. L'illusionniste y est chez lui."], xp=200),
   quest("Monastere perche", t_struct("dungeons_arise:monastery"),
         ["Haut, isole, et bien garde."]),
   quest("Monument oceanique", t_struct("betteroceanmonuments:ocean_monument"),
         ["Version YUNG's : la disposition n'est plus celle que tu connais par coeur."], xp=200),
   quest("Temple du desert", t_struct("betterdeserttemples:desert_temple"),
         ["Refait de fond en comble par YUNG's, pieges compris."]),
   quest("Temple de la jungle", t_struct("betterjungletemples:jungle_temple"),
         ["Meme chose cote jungle."]),
   quest("Navire fantome", t_struct("aquamirae:pirate_ship"),
         ["Aquamirae : cherche l'ocean gele, le navire n'est jamais loin."], xp=200),
   quest("Village de grenouilles", t_struct("ribbits:ribbit_village"),
         ["Dans les marais. Pacifique, pour une fois."]),
   quest("Cabane de l'iceologer", t_struct("friendsandfoes:iceologer_cabin"),
         ["Friends&Foes : l'iceologer est un mob du vote Mojang."]),
   quest("Le labyrinthe", t_struct("illagerinvasion:labyrinth"),
         ["Rare. On n'en ressort pas toujours."],
         deps=["La tour de l'illusionniste"], hidden=True, xp=300),
   quest("Keep Kayra", t_struct("dungeons_arise:keep_kayra"),
         ["Une des plus grosses structures du pack."],
         deps=["Le fort des illagers"], hidden=True, xp=300),
   quest("Palais de Shiraz", t_struct("dungeons_arise:shiraz_palace"),
         ["Immense, et tres loin."], deps=["Le fort des illagers"], hidden=True, xp=300),
   quest("L'asile", t_struct("dungeons_arise:plague_asylum"),
         ["Mauvaise idee. Vas-y quand meme."], deps=["Monastere perche"], hidden=True, xp=300),
   quest("La bosquet des cerisiers de Terralith", t_biome("terralith:sakura_grove"),
         ["Un des plus beaux biomes du pack. Vaut le detour rien que pour la vue."]),
   quest("La tour du Night Lich", t_struct("bosses_of_mass_destruction:lich_tower"),
         ["Bosses of Mass Destruction : elle se dresse dans les biomes froids."], xp=200),
   quest("Abattre le Night Lich", t_kill("bosses_of_mass_destruction:lich"),
         ["Premier des quatre boss du pack. Equipez-vous serieusement."],
         deps=["La tour du Night Lich"], xp=500),
      ]),
 dict(file="04_le_nether", title="Le Nether", icon="minecraft:netherrack",
      subtitle="Incendium refait tout : biomes, structures, butin",
      quests=[
   quest("Passer le portail", t_dim("minecraft:the_nether"),
         ["Le Nether d'Incendium n'a plus grand-chose a voir avec le vanilla."], xp=100),
   quest("Une forteresse", t_struct("betterfortresses:fortress"),
         ["Version YUNG's : bien plus vaste, et defendue."],
         deps=["Passer le portail"], hidden=True, xp=200),
   quest("Village piglin", t_struct("incendium:piglin_village"),
         ["Incendium. Mets ton casque en or avant d'entrer."],
         deps=["Passer le portail"], hidden=True),
   quest("Chateau interdit", t_struct("incendium:forbidden_castle"),
         ["La piece maitresse d'Incendium."],
         deps=["Une forteresse"], hidden=True, xp=300),
   quest("Le Sanctum", t_struct("incendium:sanctum"),
         ["Rare, et pas concu pour les visiteurs."],
         deps=["Une forteresse"], hidden=True, xp=300),
   quest("Affronter le Gauntlet", t_kill("bosses_of_mass_destruction:gauntlet"),
         ["Le boss du Nether. Il garde son arene."],
         deps=["Passer le portail"], hidden=True, xp=500),
      ]),
 dict(file="05_les_profondeurs", title="Les profondeurs", icon="minecraft:sculk",
      subtitle="Ce qu'il y a sous les Anciennes Cites",
      quests=[
   quest("Une cite antique", t_struct("#minecraft:ancient_city"),
         ["Le Warden est toujours la. Deeper and Darker ajoute ce qu'il y a apres."], xp=200),
   quest("Le temple ancien", t_struct("deeperdarker:ancient_temple"),
         ["C'est la que se trouve le portail vers l'Autre Cote."],
         deps=["Une cite antique"], hidden=True, xp=300),
   quest("L'Autre Cote", t_dim("deeperdarker:otherside"),
         ["Une dimension entiere derriere le portail des Anciennes Cites."],
         deps=["Le temple ancien"], hidden=True, xp=400),
   quest("Void Blossom", t_kill("bosses_of_mass_destruction:void_blossom"),
         ["Le boss du fond du monde."],
         deps=["Une cite antique"], hidden=True, xp=500),
      ]),
 dict(file="06_l_aether", title="L'Aether", icon="minecraft:feather",
      subtitle="La dimension celeste : trois donjons, trois boss",
      quests=[
   quest("Monter a l'Aether", t_dim("aether:the_aether"),
         ["Portail en glace, allume au seau d'eau. La-haut, la chute tue plus que les mobs."],
         xp=150),
   quest("Donjon de bronze", t_struct("aether:bronze_dungeon"),
         ["Le premier des trois. Slider a l'interieur."],
         deps=["Monter a l'Aether"], hidden=True, xp=300),
   quest("Donjon d'argent", t_struct("aether:silver_dungeon"),
         ["Dans les nuages. Valkyries."],
         deps=["Monter a l'Aether"], hidden=True, xp=400),
   quest("Donjon d'or", t_struct("aether:gold_dungeon"),
         ["Le dernier. Sun Spirit."],
         deps=["Donjon d'argent"], hidden=True, xp=500),
      ]),
 dict(file="07_l_end", title="L'End", icon="minecraft:ender_eye",
      subtitle="Nullscape + l'ile refaite par YUNG's",
      quests=[
   quest("Franchir le portail", t_dim("minecraft:the_end"),
         ["L'ile centrale et le combat du dragon sont refaits par YUNG's."], xp=200),
   quest("Abattre le dragon", t_kill("minecraft:ender_dragon"),
         ["Le combat n'est plus celui du vanilla."],
         deps=["Franchir le portail"], hidden=True, xp=600),
   quest("Une cite de l'End", t_struct("#minecraft:end_city"),
         ["Avec Nullscape, les iles exterieures n'ont plus rien de repetitif."],
         deps=["Abattre le dragon"], hidden=True, xp=300),
   quest("Obsidilith", t_kill("bosses_of_mass_destruction:obsidilith"),
         ["Le quatrieme boss, dans son arene de l'End."],
         deps=["Abattre le dragon"], hidden=True, xp=500),
   quest("Le squelette de dragon", t_struct("nullscape:dragon_skeleton"),
         ["Nullscape. Il y en a eu d'autres avant vous."],
         deps=["Abattre le dragon"], hidden=True, xp=300),
      ]),
]


def snbt_task(t, qid):
    lines = [f'\t\t\t\t\tid: "{nid()}"']
    for k, v in t.items():
        if k == "type":
            continue
        if isinstance(v, bool):
            lines.append(f"\t\t\t\t\t{k}: {str(v).lower()}")
        elif isinstance(v, int):
            lines.append(f"\t\t\t\t\t{k}: {v}L" if k == "value" else f"\t\t\t\t\t{k}: {v}")
        else:
            lines.append(f'\t\t\t\t\t{k}: "{esc(v)}"')
    lines.append(f'\t\t\t\t\ttype: "{t["type"]}"')
    return "{\n" + "\n".join(lines) + "\n\t\t\t\t}"


def snbt_reward(r):
    lines = [f'\t\t\t\t\tid: "{nid()}"']
    for k, v in r.items():
        if k == "type":
            continue
        if isinstance(v, bool):
            lines.append(f"\t\t\t\t\t{k}: {str(v).lower()}")
        elif isinstance(v, int):
            lines.append(f"\t\t\t\t\t{k}: {v}")
        else:
            lines.append(f'\t\t\t\t\t{k}: "{esc(v)}"')
    lines.append(f'\t\t\t\t\ttype: "{r["type"]}"')
    return "{\n" + "\n".join(lines) + "\n\t\t\t\t}"


for order, ch in enumerate(CHAPTERS):
    ids = {}
    for q in ch["quests"]:
        ids[q["title"]] = nid()
    body = []
    # grille : 3 colonnes, espacement 1.5
    for i, q in enumerate(ch["quests"]):
        x = (i % 3) * 1.5 - 1.5
        y = (i // 3) * 1.5 - 1.5
        rewards = [snbt_reward({"type": "xp", "xp": q["xp"]})]
        for r in q["rewards"]:
            rewards.append(snbt_reward(r))
        if not q["no_broadcast"]:
            rewards.append(snbt_reward(broadcast(q["title"])))
        desc = "\n".join(f'\t\t\t\t\t"{esc(d)}"' for d in q["desc"])
        lines = [
            "\t\t{",
            "\t\t\tdescription: [",
            desc,
            "\t\t\t]",
            f'\t\t\tid: "{ids[q["title"]]}"',
        ]
        if q["deps"]:
            deps = " ".join(f'"{ids[d]}"' for d in q["deps"])
            lines.append(f"\t\t\tdependencies: [{deps}]")
        if q["hidden"]:
            lines.append("\t\t\thide_until_deps_complete: true")
        lines += [
            "\t\t\trewards: [",
            "\n".join("\t\t\t\t" + r for r in rewards),
            "\t\t\t]",
            '\t\t\tshape: "circle"',
        ]
        if q["subtitle"]:
            lines.append(f'\t\t\tsubtitle: "{esc(q["subtitle"])}"')
        lines += [
            "\t\t\ttasks: [",
            "\t\t\t\t" + snbt_task(q["task"], ids[q["title"]]),
            "\t\t\t]",
            f'\t\t\ttitle: "{esc(q["title"])}"',
            f"\t\t\tx: {x:.1f}d",
            f"\t\t\ty: {y:.1f}d",
            "\t\t}",
        ]
        body.append("\n".join(lines))
    text = "\n".join([
        "{",
        "\tdefault_hide_dependency_lines: false",
        '\tdefault_quest_shape: ""',
        f'\tfilename: "{ch["file"]}"',
        '\tgroup: ""',
        f'\ticon: "{ch["icon"]}"',
        f'\tid: "{nid()}"',
        f"\torder_index: {order}",
        "\tquests: [",
        "\n".join(body),
        "\t]",
        "\tsubtitle: [",
        f'\t\t"{esc(ch["subtitle"])}"',
        "\t]",
        f'\ttitle: "{esc(ch["title"])}"',
        "}",
        "",
    ])
    (OUT / f"{ch['file']}.snbt").write_text(text, encoding="utf-8")
    print(f"{ch['file']}.snbt : {len(ch['quests'])} quetes")

print("total quetes :", sum(len(c["quests"]) for c in CHAPTERS))
