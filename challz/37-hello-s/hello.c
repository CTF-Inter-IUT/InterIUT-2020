#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <openssl/sha.h>

const unsigned char PASSWORD_HASH[SHA256_DIGEST_LENGTH] = { 0x33, 0x62, 0x9b, 0xfc, 0xf2, 0x8c, 0x95, 0xfd, 0x6c, 0xd9, 0x07, 0x5b, 0xc8, 0xe7, 0xb6, 0x32, 0xed, 0x11, 0x9c, 0xbb, 0xcb, 0x11, 0xc6, 0xb3, 0xac, 0xf7, 0xfd, 0x11, 0x91, 0x24, 0xeb, 0x89 };
unsigned char FILENAME[5] = "/flag";

unsigned char* sha256(const char *to_hash) {
	char *obuf = malloc(SHA256_DIGEST_LENGTH);
	SHA256(to_hash, strlen(to_hash), obuf);
	return obuf;
}

int main(int argc, char **argv) {
	//Read the file
	FILE *file_pointer = fopen(FILENAME, "r");  

	if (file_pointer == NULL)
	{
		perror("Error while opening the file.\n");
		exit(EXIT_FAILURE);
	}

	fseek(file_pointer, 0, SEEK_END);  
	long file_size = ftell(file_pointer);  

	unsigned char *file_content = malloc(file_size);  

	fseek(file_pointer, 0, SEEK_SET);  
	fread(file_content, 1, file_size, file_pointer);  
	fclose(file_pointer);  

	if (argc > 1 ) {
		//Compute hash
		unsigned char *hashed_input = sha256(argv[1]);
		bool are_the_same = true;
		int i=0;

		//Compare hash
		while (i < SHA256_DIGEST_LENGTH) {
			if (hashed_input[i] != PASSWORD_HASH[i])
				are_the_same = false;
			i++;
		}

		if (are_the_same) {
			//Print the file content
			i = 0;
			while (i < file_size) {
				printf("%c",file_content[i]);
				i++;
			}
		} else {
			printf("Wrong pass !\n");
		}
	} else {
		printf(argv[0]); printf(" <password_for_flag>\n");
	}
	return 0;
}
