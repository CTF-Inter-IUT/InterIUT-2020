#!/usr/bin/python2
# coding: utf8

import random


def show():
    print u"=========="
    print u"Machine à sous du turfu en Python 2 !"
    print u"Vous avez 5 tours pour gagner un max de sous"
    print u"Si vous obtenez 1'000'000 de sous, le jeu 'print flag'."
    print u"=========="
    print u""


def main():
    flag = u"ENSIBS{pYTh0n_tWo_iS_uP_to_d4t3}"
    money = 100
    turn = 0

    show()

    while (money > 0) and (turn < 5):
        print u"Nombre de tours : " + str(turn)
        print u"Votre argent : " + str(money)
        bet = input(u"Combien parier : ")
        print u"Vous avez parié " + str(bet)

        if abs(bet) <= money:
            money -= abs(bet)
            if random.randint(0, 100) >= 66:
                money += (int(abs(bet))*3)
                print u"Bien joué"
            else:
                print u"RIP"
        else:
            print u"Pas possible mec"

        turn += 1
        print u""


if __name__ == "__main__":
    main()
