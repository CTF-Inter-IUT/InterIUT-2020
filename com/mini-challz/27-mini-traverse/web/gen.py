#!/usr/bin/env python3
#coding: utf-8

from os import rmdir, system
import json

with open("spells.json", "r") as f:
    spells_json = json.loads(f.read())

index = """
# Liste des sorts
"""
for c in spells_json["section_order"]:
    index += "[" + c + "](/?file=" + c +".md), "
    with open(c + ".md", "w") as f:
        f.write("# [Lettre " + c + "](/)\n\n")
        for spell in spells_json["sections"][c]:
            f.write("**" + spell["key"] + "** : " + spell["val"] + "\n\n")

for c in spells_json["section_order"]:
    try:
        pass#system("rm " + c)
    except:
        pass

with open("index.md", "w") as f:
    f.write(index)
