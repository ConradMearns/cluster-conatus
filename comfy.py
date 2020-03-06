#!/usr/bin/python3
import argparse
import requests
import json

import sys, tempfile, os
from subprocess import call

EDITOR = os.environ.get('EDITOR','vim')
host = "mopi-a.local"
port = "5984"
user = "admin"
passwd = "passwort"

parser = argparse.ArgumentParser(description='Use CouchDB and be Comfy')
parser.add_argument('--host', default=host)
parser.add_argument('--port', default=port)
parser.add_argument('-read', nargs='+')
parser.add_argument('-create', nargs=2)
parser.add_argument('-update', nargs=2)

args = parser.parse_args()
host = args.host
port = args.port

def FormatHost():
    return 'http://' + host + ":" + port

def GetDocument(db, document):
    a = FormatHost() +'/'+db+'/'+document+'/'
    resp = requests.get(a, auth=(user, passwd))
    if resp.status_code != 200:
        print("Could not get '"+document+"':", resp.status_code, resp.json()["reason"])
    else:
        print(resp.json()["body"])

def GetAllDocuments(db):
    a = FormatHost() +'/'+db+'/_all_docs'
    resp = requests.get(a, auth=(user, passwd))
    if resp.status_code != 200:
        print("Could not get documents:", resp.status_code, resp.json()["reason"])
    else:
        for doc in resp.json()["rows"]:
            print(doc["id"])
        # return resp.json()

def PutDocument(db, document, data):
    a = FormatHost() +'/'+db+'/'+document+'/'
    headers = {'Accept': 'application/json', "Content-Type": "application/json"}
    resp = requests.put(a, headers=headers, data=data, auth=(user, passwd))
    if resp.status_code != 201 and resp.status_code != 202:
        print("Could not put document:", resp.status_code, resp.json()["reason"])
    else:
        print(resp.status_code)

def GetMessageFromEditor(msg=None):
    initial_message = b""
    if msg is not None:
        initial_message = msg

    with tempfile.NamedTemporaryFile(suffix=".tmp") as tf:
        tf.write(initial_message)
        tf.flush()
        call([EDITOR, tf.name])
        tf.seek(0)
        return tf.read().decode("utf-8")
    
def GetDocumentData(db, document):
    a = FormatHost() +'/'+db+'/'+document+'/'
    resp = requests.get(a, auth=(user, passwd))
    if resp.status_code != 200:
        print("Could not get '"+document+"':", resp.status_code, resp.json()["reason"])
    else:
        return (resp.json()["body"], resp.json()["_rev"])

###############################################################

if args.read:
    if len(args.read) == 1:
        db = args.read[0]
        GetAllDocuments(db)
    elif len(args.read) > 1:
        db = args.read[0]
        for doc in args.read[1:]:
            GetDocument(db, doc)

elif args.create:
    msg = GetMessageFromEditor()
    db = args.create[0]
    doc = args.create[1]

    data = {"body": msg}

    PutDocument(db, doc, json.dumps(data))

elif args.update:
    db = args.update[0]
    doc = args.update[1]

    body, rev = GetDocumentData(db, doc)
    msg = GetMessageFromEditor(str.encode(body))

    data = {"body": msg, "_rev": rev}

    PutDocument(db, doc, json.dumps(data))
