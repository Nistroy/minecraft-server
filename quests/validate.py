"""Verifie que chaque id reference par les chapitres existe dans les jars installes.

Usage : python3 quests/validate.py [dossier_mods] [dossier_chapitres]
Defauts : server/mods et server/world/ftbquests/quests/chapters.
"""
import re, pathlib, sys, zipfile
ROOT = pathlib.Path(__file__).resolve().parent.parent
mods = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "server/mods"
structs, tags, biomes, ents, dims, items = set(), set(), set(), set(), set(), set()
for j in mods.glob("*.jar"):
    try: z = zipfile.ZipFile(j)
    except Exception: continue
    for n in z.namelist():
        m = re.match(r"data/([^/]+)/worldgen/structure/(.+)\.json$", n)
        if m: structs.add(f"{m.group(1)}:{m.group(2)}")
        m = re.match(r"data/([^/]+)/tags/worldgen/structure/(.+)\.json$", n)
        if m: tags.add(f"#{m.group(1)}:{m.group(2)}")
        m = re.match(r"data/([^/]+)/worldgen/biome/(.+)\.json$", n)
        if m: biomes.add(f"{m.group(1)}:{m.group(2)}")
        m = re.match(r"data/([^/]+)/dimension/(.+)\.json$", n)
        if m: dims.add(f"{m.group(1)}:{m.group(2)}")
        m = re.match(r"assets/([^/]+)/lang/en_us\.json$", n)
        if m:
            try: txt = z.read(n).decode("utf-8", "ignore")
            except Exception: continue
            for k in re.findall(r'"entity\.([a-z0-9_]+)\.([a-z0-9_]+)"', txt): ents.add(f"{k[0]}:{k[1]}")
            for k in re.findall(r'"(?:item|block)\.([a-z0-9_]+)\.([a-z0-9_]+)"', txt): items.add(f"{k[0]}:{k[1]}")
# vanilla
van = mods.parent / "versions/1.21.1/server-1.21.1.jar"
if van.exists():
    z = zipfile.ZipFile(van)
    for n in z.namelist():
        m = re.match(r"data/([^/]+)/worldgen/structure/(.+)\.json$", n)
        if m: structs.add(f"{m.group(1)}:{m.group(2)}")
        m = re.match(r"data/([^/]+)/tags/worldgen/structure/(.+)\.json$", n)
        if m: tags.add(f"#{m.group(1)}:{m.group(2)}")
        m = re.match(r"data/([^/]+)/worldgen/biome/(.+)\.json$", n)
        if m: biomes.add(f"{m.group(1)}:{m.group(2)}")
ents |= {"minecraft:ender_dragon"}
dims |= {"minecraft:the_nether", "minecraft:the_end", "minecraft:overworld"}
items |= {"waystones:waystone", "bountiful:bountyboard"}

ch = pathlib.Path(sys.argv[2]) if len(sys.argv) > 2 else ROOT / "server/world/ftbquests/quests/chapters"
bad = []
for f in sorted(ch.glob("*.snbt")):
    t = f.read_text()
    for kind, pat, pool in (("structure", r'structure: "([^"]+)"', structs | tags),
                            ("biome", r'biome: "([^"]+)"', biomes),
                            ("dim", r'dim: "([^"]+)"', dims),
                            ("entity", r'entity: "([^"]+)"', ents),
                            ("item", r'item: "([^"]+)"', items)):
        for v in re.findall(pat, t):
            if v not in pool: bad.append((f.name, kind, v))
print("structures connues:", len(structs), "| tags:", len(tags), "| biomes:", len(biomes))
if bad:
    print("INTROUVABLES:")
    for b in bad: print("  ", *b)
    sys.exit(1)
print("OK : tous les ids references existent")
