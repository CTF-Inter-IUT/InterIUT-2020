#!/usr/bin/env python3
# coding: utf-8

import json
from users import User, RichGuy
from flask import Flask, request, jsonify
from flask_redis import FlaskRedis
from Crypto.PublicKey import RSA

def get_tid() -> str:
    redis_client.incr('tid')
    incremented_tid: str =  redis_client.get('tid').decode().zfill(12)
    return incremented_tid[:4] + '-' + incremented_tid[4:-4] + '-' + incremented_tid[-4:]

def save_db(u):
    redis_client.set(u.id, json.dumps(u.__dict__))

def get_db(u):
    u = u.decode()
    return json.JSONDecoder(object_hook = User.from_json).decode(u)

# --- RSA encryption ------

def decrypt(ciphertext: int) -> int:
    return pow(ciphertext,keypair.d,keypair.n)

# --- Data & server setup ------
app = Flask(__name__)
redis_client = FlaskRedis(app)

with open("./priv_key","r") as f:
    keypair = RSA.importKey(f.read())
with open('/flag', 'r') as f:
    FLAG = f.read()

users = {}

rich_guy = RichGuy("Patrick", "Balkany")
rich_guy.id = '2021-6329-0004'
save_db(rich_guy)
redis_client.set('tid', 674983610289)

MAX_ATTEMPTS = 1
MONEY_NEEDED = 1000

@app.route('/', methods = ['POST', 'GET'])
def health():
    return jsonify({"status": "Weird, why are you coming here ?"})

# --- Final routes -------------------------
@app.route('/transactions/make', methods = ['POST'])
def make_transaction():
    data = request.form

    if "sender" not in data:
        return jsonify({"error": "You must specify a sender"})

    if "receiver" not in data:
        return jsonify({"error": "You must specify a receiver"})

    if not "rsa-encrypted-amount" in data and not data["rsa-encrypted-amount"].isdigit():
        return jsonify({"error": "You must specify the amount as an int"})

    # Check if the redis_client.get('users') provided are correct
    if not redis_client.exists(data["sender"]):
        return jsonify({"error": "User " + data["sender"] + " doesn't exist"})

    if not redis_client.exists(data["receiver"]):
        return jsonify({"error": "User " + data["receiver"] + " doesn't exist"})


    sender = get_db(redis_client.get(data["sender"]))
    receiver = get_db(redis_client.get(data["receiver"]))
    amount = decrypt(int(data["rsa-encrypted-amount"]))
    try:
        sender.send_money_to(receiver, amount)
    except ValueError as e:
        return jsonify({"error": str(e)})

    save_db(sender)
    save_db(receiver)
    transaction_id = get_tid()
    if receiver.nb_transac <= MAX_ATTEMPTS and receiver.balance > MONEY_NEEDED:
        return jsonify({"flag": FLAG})
    elif receiver.balance > MONEY_NEEDED:
        return jsonify({"not flag": "Well played ! But you made it in too much transactions"})
    else:
        return jsonify({"tid": transaction_id})

@app.route('/users/create', methods = ['POST'])
def create_user():
    data = request.form

    if "lastname" not in data:
        return jsonify({"error": "You must specify a lastname"})

    if "name" not in data:
        return jsonify({"error": "You must specify a name"})

    new_user = User(data["name"], data["lastname"])
    redis_client.set(new_user.id, json.dumps(new_user.__dict__))

    return jsonify({"uid": new_user.id})

@app.route('/users/get-infos', methods = ['POST'])
def get_user_infos():
    data = request.form

    if "uid" not in data:
        return jsonify({"error": "You must specify a uid"})

    if not redis_client.exists(data["uid"]):
        return jsonify({"error": "User " + data["uid"] + " doesn't exist"})

    user = get_db(redis_client.get(data["uid"]))
    return jsonify({"user": {"name": user.name, "lastname": user.lastname, "balance": user.balance, "nb_transactions": user.nb_transac}})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
