#!/usr/bin/env python3
#coding: utf-8

from random import randint
from hashlib import sha256
from flask import Flask, request, render_template, jsonify

LEET_TABLE = {
	'a': '4',
	'e': '3',
	'l': '1',
	't': '7',
	'o': '0',
	's': '5',
}

app = Flask(__name__)
app.connections = {}

def hash(data):
	h = sha256()
	h.update(bytes(data, 'utf-8'))
	return h.hexdigest()

def leet(msg):
	leet_msg = ''
	for c in msg.lower():
		leet_msg += LEET_TABLE.get(c,c)
	return leet_msg

def new_token():
	new_token.idx += 1
	return hash(str(new_token.idx).rjust(10))
new_token.idx = 0

@app.errorhandler(404)
def page_not_found(e):
    return render_template('error.html',
    	error_code="404",
    	error_name="Page not found",
    	error_content="Go back to work Mr Anderson"
    ), 404

@app.errorhandler(405)
def method_not_allowed(e):
    return render_template('error.html',
    	error_code="405",
    	error_name="Method not allowed",
    	error_content="We don't do that here"
    ), 405

@app.route('/')
def index():
	return render_template('tea_house.html')

@app.route('/challenge', methods=['POST'])
def challenge():
	if "token" in request.form:
		tkn = request.form["token"]
		if tkn in app.connections:
			app.connections[tkn] += 1
			if app.connections[tkn] > 100:
				return jsonify({
					"congratz": "First step completed, gg wp",
					"next_step": "/wake_up_my_dear_"
				})
			else:
				return jsonify({
					"calculus": get_calculus()
				})
		else:
			return jsonify({"error": "Unknown token"})
	else:
		tkn = new_token()
		app.connections[tkn] = 0
		return jsonify({
			"token": tkn,
			"1337": "c4c4"
		})

@app.route('/wake_up_my_dear_')
def scare_player():
	return render_template('wake_up.html')

@app.route('/health-check', methods=['GET', 'POST'])
def still_ok():
	return jsonify({"status": "ok"})

app.register_error_handler(404, page_not_found)
app.register_error_handler(405, method_not_allowed)

if __name__ == '__main__':
	app.run(debug=False, host='0.0.0.0')
