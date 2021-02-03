#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//ENSIBS{1st_y0u_sh4l1_n0t_5har3_fl4g5}
const int FLAG_LEN = 37;
//const int *FLAG = "ENSIBS{1st_y0u_sh4l1_n0t_5har3_fl4g5}";
const int FLAG[] = { 0x77 ,0x4c ,0x41 ,0x4b ,0x70 ,0x41 ,0xffffffb9 ,0x63 ,0xffffffa1 ,0xffffffa6 ,0x5d ,0xffffffbb ,0x62 ,0xffffffa7 ,0x5d ,0xffffffa1 ,0xffffffaa ,0x66 ,0xffffffae ,0x63 ,0x5d ,0xffffffac ,0x62 ,0xffffffa6 ,0x5d ,0x67 ,0xffffffaa ,0x53 ,0xffffffa0 ,0x61 ,0x5d ,0x54 ,0xffffffae ,0x66 ,0x55 ,0x67 ,0xffffffbf};


int main(int argc __attribute__((unused)), char **argv __attribute__((unused))) {
	printf("Please enter the flag > ");

	char line[FLAG_LEN + 1];
	if (fgets(line, sizeof(line), stdin)) {
		int input_size = strlen(line);
		if (input_size == FLAG_LEN) {
			for (int i = 0; i < input_size; i++) {
				line[i] = ((line[i] + 24) ^ 42);
			}
			for (int i = 0; i < input_size; i++) {
				if (line[i] != FLAG[i]) {
					printf("https://tinyurl.com/snyyqw7 !\n");
					return 1;
				}
			}

			printf("Bien joué !\nEnvoyez nous le flag en MP sur Twitter @CTF_Inter_IUT pour prouver votre talent\n");
		} else {
			printf("C'est non !\n");
			return 1;
		}
	} else {
		printf("C'est non !\n");
		return 1;
	}

return 0;
}
