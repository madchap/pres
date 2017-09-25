#!/usr/bin/env python3

# Fred Blaise
# quick n' dirty demo encryption as a service with Vault transit, using a local vault server
# uses the "useme" endpoint of the transit mount

# Takes 2 args (no check is made)
    # 'decrypt' or 'encrypt' as 1st positional
    # a string to convert

# uses VAULT_TOKEN env variable

import os
import hvac
from sys import argv
import base64
import json

def do_encrypt(astring):
    json_output = vc.write('transit/encrypt/useme', plaintext=base64.b64encode(str.encode(astring)))
    print('Encrypted value is: {0}'.format(json_output['data']['ciphertext']))


def do_decrypt(astring):
    json_output = vc.write('transit/decrypt/useme', ciphertext=astring)
    print('Decrypted value is: {0}'.format(base64.b64decode(json_output['data']['plaintext'])))


if __name__ == "__main__":
    scriptname, action, astring = argv

    vc = hvac.Client(url='http://localhost:8200', token=os.environ['VAULT_TOKEN'])
    assert vc.is_authenticated()

    if action == "encrypt":
             do_encrypt(astring)
    elif action == "decrypt":
             do_decrypt(astring)
