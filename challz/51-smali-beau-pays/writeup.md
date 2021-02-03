# SMALI un beau pays

C'est du reverse de SMALI, on voit que y'a un check de password de fait, il faut donner le bon mot de passe pour flag.

C'est la fonction `checkPassword()` qui se charge de dire si c'est le bon mot de passe.

Y'a des `equals()` de faits sur des substrings de l'input user et des strings hardcodées et encodées en base64, il faut reconstituer le flag bout par bout.
