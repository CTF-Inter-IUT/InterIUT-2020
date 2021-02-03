#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define STR_LEN 64
#define MALE 'M'
#define FEMALE 'F'

typedef struct moron {
	int qi;
	char sex;
	char name[STR_LEN];
	char display[STR_LEN];
} person;

int compute_qi() {
	return rand() % 100 + 20;
}

person* new_p() {
	person *p = malloc(sizeof(person));
	p->sex = 'X';
	strncpy(p->display, "[%.20s|%c] dispose d'un QI de %d pts\n", STR_LEN);
	p->qi = 4;
	return p;
}

int main(int argc, char **argv) {
	/* Intializes random number generator */
	time_t t;
	srand((unsigned) time(&t));
	setvbuf(stdin, NULL, _IONBF, 0);
	setvbuf(stdout, NULL, _IONBF, 0);
	setvbuf(stderr, NULL, _IONBF, 0);

	person *user = new_p();

	printf("Nom : ");
	scanf("%s", &user->name);

	user->sex = 'X';
	while (user->sex != MALE && user->sex != FEMALE) {
		printf("Sexe [%c/%c] : ", MALE, FEMALE);
		scanf(" %c", &user->sex);
	}

	user->qi = compute_qi();
	printf(user->display, user->name, user->sex, user->qi);

	if (user->qi > 128) {
		puts("H2G2{FLAG}");
	} else {
		puts("Vous êtes sûrs d'être en bonne santé ?");
	}


	return 0;
}
