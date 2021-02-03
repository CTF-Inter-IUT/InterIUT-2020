#!/usr/bin/env python3
# -*- encoding: utf-8 -*-

from flask import Flask, render_template_string, request

import html
import random

app = Flask(__name__)

app.config["SUPER_SECRET_ROUTE"] = "/_5uPer_s3cret_"

template = '''
<!doctype html>
<html>
    <head>
        <title>Ninja name generator</title>
        <link rel="stylesheet" type="text/css" href="/static/css/style.css">
    </head>
    <body>
        <h1>Ninja name generator !</h1>
        <h2>Générez automatiquement votre super nom de ninja !</h2>

        <p>Votre nom de ninja : <span id="ninja_name">{}</span> !</p>

        <form>
            <input type="text" name="name" placeholder="Votre nom...">
            <input type="submit" name="submit" value="Générer !">
        </form>
        <script>s = document.getElementById("ninja_name");s.innerHTML = s.innerHTML.replace(/</g, "&lt;").replace(/>/g, "&gt;")</script>
    </body>
</html>
'''

def name_generator(name):
    words = ["Katana", "Shuriken", "Kunai", "Tekken", "Shikoro"]
    word = words[random.randint(0, len(words) - 1)]
    if random.randint(0,1) == 0:
        return word + " " + name
    else:
        return name + " " + word

def random_name():
    names = ["Peepoodoo", "Moruto", "Caca-Chie", "Sasue-Qué", "Sacoura"]
    return names[random.randint(0, len(names) - 1)]

@app.route("/")
def start():
    name = request.args.get("name") or random_name()
    return render_template_string(template.format(html.escape(name_generator(name))))

@app.route("/_5uPer_s3cret_")
def secret():
    secret_template = open("/flag","r").readline()
    return render_template_string(secret_template)

if __name__ == '__main__':
    app.run(host = '0.0.0.0', port = 80, debug = False)
