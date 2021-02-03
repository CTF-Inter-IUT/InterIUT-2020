#!/usr/bin/env python3

from requests import request, Session
from argparse import ArgumentParser
from re import search
import json

argparse = ArgumentParser()
argparse.add_argument('--hostname', required=True)
argparse.add_argument('--port', default="80")
argparse.add_argument('--name', required=True)
argparse.add_argument('--username', required=True)
argparse.add_argument('--password', required=True)
argparse.add_argument('--email', required=True)
argparse.add_argument('--user-mode', help="users/teams", default="teams")
argparse.add_argument('--create-access-token', action='store_true')
argparse.add_argument('--disable-registration', action='store_true')

args = argparse.parse_args()
hostname = args.hostname
port = args.port
name = args.name
username = args.username
password = args.password
email = args.email
user_mode = args.user_mode

output = {
    'hostname': hostname,
    'port': port,
    'name': name,
    'username': username,
    'password': password,
    'email': email,
    'user_mode': user_mode,

    'success': False,
    'message': None,
    'access_token': "Not Requested",
}

baseUrl = f'http://{hostname}:{port}'
setupUrl = f'{baseUrl}/setup'

session = Session()

if session.get(baseUrl).url.find('setup') == -1:
    output['message'] = 'Error: This CTFd instance is already configured'
    print(json.dumps(output, indent=4))
    exit(1)

nonceResponse = session.get(setupUrl)
nonce = search(r'\'csrfNonce\': "([\d\w]+)"', nonceResponse.text).group(1)

response = session.post(setupUrl, data={
    'nonce': nonce,
    'ctf_name': name,
    'name': username,
    'email': email,
    'password': password,
    'user_mode': user_mode,
})

if response.history[0].status_code == 302:
    output['message'] = 'CTFd was configured successfully'

if args.create_access_token:
    try:
        nonce = search(r'\'csrfNonce\': "([\d\w]+)"', response.text).group(1)
        output['access_token'] = session.post(f'{baseUrl}/api/v1/tokens', json={}, headers={ 'CSRF-Token': nonce }).json()['data']['value']

    except Exception as e:
        output['message'] = f'Unable to create access token : "{e}"'
        print(json.dumps(output, indent=4))
        exit(1)

    if args.disable_registration:
        try:
            session.patch(f'{baseUrl}/api/v1/configs/registration_visibility', json={ 'value': 'private' }, headers={ 'Authorization': f'Token {output["access_token"]}' }).json()

        except Exception as e:
            output['message'] = f'Unable to disable registration : "{e}"'
            print(json.dumps(output, indent=4))
            exit(1)

output['success'] = True
print(json.dumps(output, indent=4))
