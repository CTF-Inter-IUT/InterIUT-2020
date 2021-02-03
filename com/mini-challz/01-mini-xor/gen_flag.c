#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const int FLAG_LEN = 37;
const int *FLAG = "ENSIBS{1st_y0u_sh4l1_n0t_5har3_fl4g5}";
//const int FLAG[] = ;

int main(int argc __attribute__((unused)), char **argv __attribute__((unused))) {
	printf("const int FLAG[] = {");
	for (int i = 0; i <= FLAG_LEN; i++) {
		if (i == FLAG_LEN) {
			printf("%d };\n",((FLAG[i] + 24) ^ 42) & 0xff);
		} else {
			printf("%d, ",((FLAG[i] + 24) ^ 42) & 0xff);
		}
	}

	return 0;
}

