#!/usr/bin/env python3
#coding: utf-8

from os import path
from markdown import Markdown
from flask import Flask, request, render_template, jsonify, redirect

app = Flask(__name__)
html_converter = Markdown()

@app.route('/')
def index():
	if "file" in request.args:
		filename = request.args["file"]
		if path.exists(filename):
			with open(filename, 'r') as f:
				content = f.read()
			content = html_converter.convert(content)
			return render_template("index.html", file_content=content)
		return render_template("index.html")
	else:
		return redirect("/?file=index.md")

if __name__ == '__main__':
	app.run(debug=False, host='0.0.0.0')

