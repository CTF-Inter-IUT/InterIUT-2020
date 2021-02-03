#!/usr/bin/env python3
#coding: utf-8

import json
import yaml
import subprocess
from argparse import ArgumentParser
from os import listdir
from os.path import isdir, isfile
from googleapiclient.discovery import build
from google.oauth2 import service_account

CTFCLI_FILE = 'challenge.yml'
CHALLS_DIR = 'challz/'
DEFAULT_DATA_FILE = "dev_data.json"
DEFAULT_STD_FLAG_FORMAT = "FAKECTF{{{flag}}}" # ;))))
CHALL_FILES_DIR = "files/"
GEN_CHALL_FILE = "add_flag.py"

SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']
INTERIUT_SHEET = '1rZb1-wM9p-_tqBVkRZrZO4bi7o-pblNc-xsjmJnptxc'
CHALL_DEF_RANGE = 'Challenges!B7:L85'

class SheetVal():
	ID = 0
	NAME = 1
	DESCRIPTION = 2
	TECHNICAL_DESCRIPTION = 3
	HINTS = 4
	AUTHOR = 5
	DIFFICULTY = 6
	CATEGORY = 7
	VALUE = 8
	REQUIREMENTS = 9
	FLAGS = 10

def parse_drvdat(text, sep='\n'):
	text = text.strip()
	if text != '':
		return text.split(sep)

def get_chall_data(chall_dir, challs_data):
	# Check if the challenge exists with its ID
	c_id = chall_dir[:2].lstrip('0')
	i = 0
	found = False
	while i < len(challs_data) and not found:
		if challs_data[i][SheetVal.ID] == c_id:
			found = True
			return challs_data[i]
		else:
			i+=1

# Get root directory of the project before exploring it
parser = ArgumentParser(description='Prepare repository to deploy')
parser.add_argument('-f', '--file', type=str, help='Use the local file specified')
parser.add_argument('-s', '--store', action='store_true', help='Store drive result in local file')
parser.add_argument('-r', '--root-directory', type=str, help='Force specific root directory')
parser.add_argument('-g', '--flag-format', type=str, help='Define the flag format')
args = parser.parse_args()

# Get root directory
root_dir = args.root_directory 
if not root_dir:
	root_dir = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True).stdout.decode().strip() + '/'

if args.flag_format:
	DEFAULT_STD_FLAG_FORMAT = args.flag_format

# Get drive data according to argument
if args.file:
	print("Récupération des données des challenges en local")
	if isfile(args.file):
		print("Lecture à partir du fichier " + args.file)
		with open(args.file,'r') as dev_cache:
			challs_data = json.loads(dev_cache.read())
	elif isfile(DEFAULT_DATA_FILE):
		print("Lecture à partir du fichier " + DEFAULT_DATA_FILE)
		with open(DEFAULT_DATA_FILE,'r') as dev_cache:
			challs_data = json.loads(dev_cache.read())
	else:
		print("Could not read " + args.file + " nor " + DEFAULT_DATA_FILE)
		exit(1)
else:
	print("Connexion au drive pour récupérer les données des challenges")
	creds = service_account.Credentials.from_service_account_file('credentials.json', scopes=SCOPES)
	service = build('sheets', 'v4', credentials=creds)
	sheet = service.spreadsheets()
	result = sheet.values().get(
		spreadsheetId=INTERIUT_SHEET,
		range=CHALL_DEF_RANGE
		).execute()
	challs_data = result.get('values', [])
	if args.store:
		print("Stockage des données des challenges en local")
		with open(DEFAULT_DATA_FILE,'w') as dev_cache:
			dev_cache.write(json.dumps(challs_data))



challs = listdir(root_dir + CHALLS_DIR)
print("Remplissage des challenge.yml pour ctfcli")
for c in challs:
	chall_path = root_dir + CHALLS_DIR + c + '/'
	c_data = get_chall_data(c, challs_data)

	if c_data:
		# Analyse et utilise les données récupérées sur le drive
		challenge = {}
		challenge["state"] = "visible"
		challenge["type"] = "standard"
		challenge["name"] = c_data[SheetVal.NAME]
		challenge["author"] = c_data[SheetVal.AUTHOR]
		challenge["description"] = c_data[SheetVal.DESCRIPTION]
		challenge["category"] = c_data[SheetVal.CATEGORY]
		challenge["value"] = c_data[SheetVal.VALUE]

		hint_list = parse_drvdat(c_data[SheetVal.HINTS])
		if hint_list:
			challenge["hints"] = hint_list
			
		# Check if the flag adding script exists then, make it cantbeshared
		if isfile(chall_path + GEN_CHALL_FILE):
			# The flag format is not used since it will provisioned by the plugin
			challenge["flags"] = [
				{
					"type": "cantbeshared",
					"content": c_data[SheetVal.FLAGS]
				}
			]
		else:
			# We use the standard flag format
			challenge["flags"] = [ DEFAULT_STD_FLAG_FORMAT.format(flag=elt) for elt in parse_drvdat(c_data[SheetVal.FLAGS])]
			
		requirement_list = parse_drvdat(c_data[SheetVal.REQUIREMENTS])
		if requirement_list:
			challenge["requirements"] = requirement_list

		# Tente d'utiliser les données du sytème de fichier
		file_list = []	
		if isdir(chall_path + CHALL_FILES_DIR):
			challenge["files"] = [CHALL_FILES_DIR + elt for elt in listdir(chall_path + CHALL_FILES_DIR)]

		print("Challenge.yml de " + c + " complété")
		with open(chall_path + CTFCLI_FILE, 'w') as f:
			f.write(yaml.dump(challenge, allow_unicode=True))

