Il faut xorer la version en clair du logo du ctf avec la version donnee pour retrouver la cle de dechiffrement pour ensuite dechiffere le message.

Le script suivant permet de solve le chall

```{.python}
#!/usr/bin/env python3
key = b''

logo = open('logo.jpg', 'rb').read()
logo_enc = open('logo.jpg.enc', 'rb').read()

for i in range(len(logo)):
    key += bytes([logo[i] ^ logo_enc[i]])

message_enc = open('message.txt.enc', 'rb').read()
message = b''

for i in range(len(message_enc)):
	message += bytes([message_enc[i] ^ key[i]])

print(message)
```
