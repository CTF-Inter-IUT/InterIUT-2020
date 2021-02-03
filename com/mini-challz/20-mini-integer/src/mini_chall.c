#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

void get_the_moula() {
	FILE *file_pointer = fopen("flag", "r");  

	fseek(file_pointer, 0, SEEK_END);  
	long file_size = ftell(file_pointer);  
	unsigned char *file_content = malloc(file_size);  
	rewind(file_pointer);
	fread(file_content, 1, file_size, file_pointer);  
	fclose(file_pointer);  
	int i = 0;
	while (i < file_size) {
		printf("%c",file_content[i]);
		i++;
	}
}

bool check(short moulant) {
	return moulant <= 0;
}

int main(int argc, char **argv) {
	int start = 1000;
	int user_input;

	do {
		puts("Veuillez rentrer votre montant de moula");
		scanf("%d", &user_input);
	} while (user_input <= 0);

	if (check(user_input)) {
		get_the_moula();
	} else {
		puts("Vous disposez de trop de moula, vous n'en méritez pas plus");
	}
	return 0;
}
