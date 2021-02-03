#!/usr/bin/env python3
#coding: utf-8

import monsql
from flask import Flask, request, render_template, jsonify
from flaskext.mysql import MySQL
from pymysql.err import ProgrammingError

app = Flask(__name__)
app.config['MYSQL_DATABASE_USER'] = "monsql-1"
app.config['MYSQL_DATABASE_PASSWORD'] = "cZEORwzLNiUaZiiLYnkSTvqZzWbSXiWWNdplDWTyIjmWQ0x"
app.config['MYSQL_DATABASE_DB'] = 'base_de_donnees'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'

mysql = MySQL()
mysql.init_app(app)

@app.route('/')
def index():
	return render_template('index.html')

@app.route('/demo-monsql', methods=['POST'])
def make_request():
	monsql_req = request.form.get("requete")

	try:
		# MySQL Connection
		connection = mysql.connect()
		cursor = connection.cursor()
		# Get current values
		translated = monsql.translate(monsql_req)
		print(translated)
		cursor.execute(translated)
		results = cursor.fetchall()
		cursor.close()
		connection.close()
		#TODO handle errors
		return jsonify({"statut": "ok", "résultat": results})
	except ConnectionRefusedError:
		return jsonify({"statut": "ko", "résultat": results})
	except (ProgrammingError, monsql.ErreurDeTraduction) as e:
		print()
		if hasattr(e, 'message'):
			return jsonify({"statut": "ko", "résultat": e.message})
		else:
			return jsonify({"statut": "ko", "résultat": str(e)})
	except Exception:
		return jsonify({"statut": "ko", "résultat": "Mauvaise requête"})

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0')
