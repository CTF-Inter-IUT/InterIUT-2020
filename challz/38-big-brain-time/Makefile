CFLAGS += -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs \
		  -Wjump-misses-init -Wlogical-op

LIBRARIES=

big_brain.out: big_brain.o
	${CC} $< -no-pie -g -std=c18 -m32 ${CFLAGS} -o $@ ${LIBRARIES}

%.o: %.c
	${CC} -no-pie -g -c  -m32 $< -o $@
