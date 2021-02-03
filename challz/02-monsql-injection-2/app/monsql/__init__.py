#!/usr/bin/env python3
#coding: utf-8

import json

DICTIONNARY = {'keywords': {'LARACINEDUCARRÉDE': 'ABS', 'LINTÉGRALITÉDE': 'ALL', 'MODIFIE': 'ALTER', 'AINSIQUE': 'AND', 'LUNDES': 'ANY', 'CONNUSOUSLENOMDE': 'AS', 'INCRÉMENTATIONAUTOMATIQUE': 'AUTO_INCREMENT', 'MOYENNE': 'AVG', 'INTERCALERENTRE': 'BETWEEN', 'CARACTÈRE': 'CHAR', 'VÉRIFIEQUE': 'CHECK', 'COMMETTRE': 'COMMIT', 'ASSEMBLER': 'CONCAT', 'CONTRAINTE': 'CONSTRAINT', 'DÉNOMBRE': 'COUNT', 'CRÉATIONDE': 'CREATE', 'JOINTURECROISÉE': 'CROSS JOIN', 'LABASEDEDONNÉE': 'DATABASE', 'SUPPRIME': 'DELETE', 'SANSDUPLICATIONS': 'DISTINCT', 'DIVISÉPAR': 'DIVIDE', 'JETTE': 'DROP', 'ESTPRÉSENTDANS': 'EXISTS', 'CLEFPASDECHEZNOUS': 'FOREIGN KEY', 'ÀPARTIRDE': 'FROM', 'AUTORISE': 'GRANT', 'LEPLUSGRANDDE': 'GREATEST', 'REGROUPERPAR': 'GROUP BY', 'AYANT': 'HAVING', 'SI': 'IF', 'DEDANS': 'IN', 'JOINTUREDUDEDANS': 'INNER JOIN', 'INSÉRER': 'INSERT', 'ENTIER': 'INT', 'ENTRECOUPEMENT': 'INTERSECT', 'ÀLINTÉRIEUR': 'INTO', 'EST': 'IS', 'LEPLUSPETITDE': 'LEAST', 'JOINTUREGAUCHE': 'LEFT JOIN', 'TAILLEDE': 'LENGTH', 'SEMBLABLEA': 'LIKE', 'MINUSCULER': 'LOWER', 'LECULMINANTDE': 'MAX', 'LEMOINDREDE': 'MIN', 'ÀLADIFFÉRENCEDE': 'MINUS', 'PAS': 'NOT', 'NÉANT': 'NULL', 'NOMBRE': 'NUMBER', 'LORSQUELON': 'ON', 'ORDONNERPAR': 'ORDER BY', 'OUBIEN': 'OR', 'PUISSANCE': 'POWER', 'CLEF': 'PRIMARY KEY', 'EMPÊCHE': 'RESTRICT', 'JOINTUREDROITE': 'RIGHT JOIN', 'RETOURENARRIÈRE': 'ROLLBACK', 'LARRONDIDE': 'ROUND', 'POINTDESAUVEGARDE': 'SAVEPOINT', 'SÉLECTIONNE': 'SELECT', 'DÉFINIT': 'SET', 'DORMIR': 'SLEEP', 'ADDITIONDETOUT': 'SUM', 'LATABLE': 'TABLE', 'LESTABLES': 'TABLES', 'TRONQUE': 'TRUNCATE', 'MISEENCONCUBINAGE': 'UNION', 'METÀJOUR': 'UPDATE', 'MAJUSCULER': 'UPPER', 'UTILISE': 'USE', 'VALEURS': 'VALUES', 'CARACTÈREVARIABLEVERSIONDEUX': 'VARCHAR2', 'VIDE': 'VOID', 'OÙ': 'WHERE', 'MONTREMOI': 'SHOW', 'MAINTENANT': 'SYSDATE'}, 'special_chars': {'CROISILLON': '#', 'ET': ',', 'TOUT': '*'}, 'to_be_implemented': {'VAUT': '=', 'STRICTEMENTINFÉRIEURÀ': '<', 'STRICTEMENTSUPÉRIEURÀ': '>', 'NEVAUTPAS': '<>', 'INFÉRIEUROUVAUT': '<=', 'SUPÉRIEUROUVAUT': '>='}}

class ErreurDeTraduction(Exception):
	def __init__(self, keyword):
		self.message = f"Le mot clé \"{keyword}\" n'est pas du bon français."
		super(Exception, self).__init__(self.message)

def translate(req):
	stoppers = "\"'`"
	delims = " ;" + stoppers

	translation = ""
	cur_s = ""
	i = 0
	while i < len(req):
		c = req[i]
		if c in delims:
			if cur_s.upper() in DICTIONNARY["keywords"].values():
				raise ErreurDeTraduction(cur_s)
			elif cur_s.upper() in DICTIONNARY["keywords"]:
				translation += DICTIONNARY["keywords"][cur_s.upper()]
			elif cur_s.upper() in DICTIONNARY["special_chars"]:
				translation += DICTIONNARY["special_chars"][cur_s.upper()]
			else:
				translation += cur_s
			translation += c

			# If we stumble upon quotes, skip until the next one
			if c in stoppers:
				search_for = c
				i += 1
				while req[i] != search_for:
					translation += req[i]
					i += 1
				translation += req[i]

			cur_s = ''
		else:
			if c in DICTIONNARY["special_chars"]:
				cur_s += DICTIONNARY["special_chars"][c]
			else:
				cur_s += c
		i+=1

	return translation

