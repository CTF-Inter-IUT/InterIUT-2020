#!/usr/bin/env python3
# -*- encoding: utf-8 -*-

from flask import Flask, redirect, request, render_template, render_template_string, url_for

app = Flask(__name__)

def render(page):
    return render_template('index.html', page = page)

@app.route('/')
def home():
    return render('/')

@app.route('/settings')
def settings():
    return render('/settings')

@app.route('/password-change')
def password_change():
    return render('/password-change')

@app.route('/logout')
def logout():
    return render('/logout')

@app.route('/command-sent', methods = ['POST'])
def command():
    command_sent = open('templates/command-sent.html', "r").read()
    command_sent = command_sent % request.form.getlist('cmd')[0]
    return render_template_string(command_sent)

if __name__ == '__main__':
    app.run(debug = False, host = '0.0.0.0', port = 80)
