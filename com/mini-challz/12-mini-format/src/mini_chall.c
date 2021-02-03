#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	puts("Comment vous nommez-vous ?");
	char nom[5];
	scanf("%5s", &nom);

	printf("Bonjour ");
	printf(nom);
	printf(" !");
	return 0;
}
