#!/usr/bin/env python3
#coding: utf-8

import monsql
from markdown import markdown
from os.path import isfile
from flask import Flask, request, render_template, jsonify, abort
from werkzeug.utils import secure_filename
from flaskext.mysql import MySQL
from pymysql.err import ProgrammingError


app = Flask(__name__)
app.config['MYSQL_DATABASE_USER'] = "monsql-2"
app.config['MYSQL_DATABASE_PASSWORD'] = "viCkKnlLwBbh8i1wIUE0rmCnfmnNqny9nBlcaQTVJDdZIOq"
app.config['MYSQL_DATABASE_DB'] = 'h4xx0r_db'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'

mysql = MySQL()
mysql.init_app(app)

def make_request(req, fetchall=True):
	# MySQL Connection
	connection = mysql.connect()
	cursor = connection.cursor()
	translated = monsql.translate(req)
	print(translated)
	cursor.execute(translated)
	if fetchall:
		result = cursor.fetchall()
	else:
		result = cursor.fetchone()
	cursor.close()
	connection.close()

	return result

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

@app.errorhandler(500)
def server_error(e):
	return render_template('500.html', error=e), 500

@app.route('/')
def index():
	tutorial_list = make_request("SÉLECTIONNE TOUT ÀPARTIRDE tut0ri4lz;")
	writeup_list = make_request("SÉLECTIONNE TOUT ÀPARTIRDE wr1t3_up5;")
	return render_template('index.html', wus=writeup_list, tutos=tutorial_list)

@app.route('/tutos')
def get_tutos():
	wu_id = request.args.get('id')
	req = "SÉLECTIONNE p4th_t0_f1l3 ÀPARTIRDE tut0ri4lz OÙ id = " + wu_id + ";"

	try:
		result = make_request(req, fetchall=False)
		wu_path = './assets/tutorials/' + secure_filename(result[0]) + '.md'

		if isfile(wu_path):
			with open(wu_path, 'r') as f:
				md_content = f.read()

			return render_template('writeup.html', wu=markdown(md_content))
		else:
			abort(404)
	except ConnectionRefusedError:
		return abort(500)
	except (monsql.ErreurDeTraduction, ProgrammingError):
		return abort(500, "VoltaireException : Vous avez une erreur dans votre syntaxe MonSQL : " + req)
	except Exception as err:
		return abort(500)

@app.route('/writeups')
def get_wus():
	wu_id = request.args.get('id')
	wu_code = request.args.get('acc3ss_c0d3', '')
	req = "SÉLECTIONNE TOUT ÀPARTIRDE wr1t3_up5 OÙ id = " + wu_id + ";"

	try:
		result = make_request(req, fetchall=False)
	except ConnectionRefusedError:
		return abort(500)
	except (monsql.ErreurDeTraduction, ProgrammingError):
		return abort(500, "VoltaireException : Vous avez une erreur dans votre syntaxe MonSQL : " + req)
	except Exception as err:
		return abort(500)

	wu_path = './assets/writeups/' + secure_filename(result[3]) + '.md'
	access_code = result[4]
	if access_code and wu_code == access_code:
		if isfile(wu_path):
			with open(wu_path, 'r') as f:
				md_content = f.read()

			return render_template('writeup.html', wu=markdown(md_content))
		else:
			abort(404)
	elif access_code and wu_code != access_code:
		# Ugly but I am too lazy
		return render_template('writeup.html', must_login=True, wu_id=result[0])
	else:
		if isfile(wu_path):
			with open(wu_path, 'r') as f:
				md_content = f.read()

			return render_template('writeup.html', wu=markdown(md_content))
		else:
			abort(404)

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0')
