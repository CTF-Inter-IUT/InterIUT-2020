#!/usr/bin/env python3
# coding: utf-8

from random import randrange

class User():

    @staticmethod
    def from_json(json_o):
        if "id" in json_o and "name" in json_o and "lastname" in json_o and "balance" in json_o and "nb_transac" in json_o:
            u = User(json_o["name"],json_o["lastname"])
            u.id = json_o["id"]
            u.balance = json_o["balance"]
            u.nb_transac = json_o["nb_transac"]
        return u

    @staticmethod
    def generate_id() -> str:
        uid: str = ''
        
        for i in range(3):
            uid += str(randrange(0,9999)).zfill(4) + '-'

        return uid[:-1]

    def __init__(self, name, lastname):
        self.id: str = User.generate_id()
        self.name: str = name
        self.lastname: str = lastname
        self.balance: int = 0
        self.nb_transac: int = 0

    def send_money_to(self, user, amount):
        if (self.id == user.id):
            raise ValueError("You can't make a transaction to the same user")

        if amount <= 0:
            raise ValueError("The amount can't be less or equal to 0")

        self.nb_transac += 1
        print(user)
        if not isinstance(user, RichGuy):
            self.balance -= amount
            user.balance += amount
            user.nb_transac += 1
        else:
            raise ValueError(user.get_names() + " don't wan't your money !")            

    def get_names(self):
        return self.name + ' ' + self.lastname

    def __str__(self):
        return f"[{self.id}] {self.name} {self.lastname} | {self.balance} € | {self.nb_transac} transactions so far"


class RichGuy(User):

    def __init__(self, name, lastname):
        super().__init__(name,lastname)
        self.balance: int = 100000000000000
