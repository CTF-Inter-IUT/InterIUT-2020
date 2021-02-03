/* 
 * tcpserver.c - A simple TCP echo server 
 * usage: tcpserver <port>
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <stdlib.h>
#include <argp.h>

#include <openssl/evp.h>
#include <openssl/crypto.h>
#include <openssl/rand.h>

#include "auth.h"

#define BUFSIZE 1024

//Argument parsing
char NO_DB[] = "no_db";
char LN[] = "\n";

struct argp_option options[] =
{
	{ "port", 'p', "PORT_NUMBER", 0, "TCP port the server will listen on." },
	{ "file", 'f', "FILENAME", 0, "DB file to read." },
	{ 0 }
};
struct arguments
{
	char* db_file;
	int port_number;
};

//Utilities
char* coucou_nofix(char* buf, int buf_len) {
	char tmp[2];
	char* hex_buf = malloc(buf_len*2+1);
	for (int i=0; i<buf_len; i++) {
		sprintf(tmp, "%02x", buf[i] & 0xff);
		strcat(hex_buf, tmp);
	}
	return hex_buf;
}

char* hexstr(char* buf, int buf_len) {
	int hex_len = buf_len*2;
	char* hex_buf = malloc(hex_len+1);
	for (int i=0; i<buf_len; i++) {
		sprintf(&(hex_buf[i*2]), "%02x", buf[i] & 0xff);
	}
	hex_buf[hex_len] = '\0';
	return hex_buf;
}

char* bytes(char* hex_buf, int buf_len) {
	if (buf_len % 2 == 0) {
		int b_len = buf_len/2;
		char* buf = malloc(b_len+1);
		for (int i=0; i<b_len; i++) {
			sscanf(&(hex_buf[i*2]), "%2hhx", &buf[i]);
		}
		buf[b_len] = '\0';
		return buf;
	} else {
		return NULL;
	}
}

char* give_msg(const char* msg) {
	int msg_len = strlen(msg);
	char *ret_msg = calloc(1, msg_len + 2);
	strcat(ret_msg, msg);
	strcat(ret_msg, LN);
	return ret_msg;
}

char* give_error(const char* msg) {
	int msg_len = strlen(msg);
	char *error = calloc(1, msg_len + strlen(ERR_HDR) + 2); //null byte and linefield
	strcat(error, ERR_HDR);
	strcat(error, msg);
	strcat(error, LN);
	return error;
}

//Crypto utilities
char* hash(char* data, int data_len) {
	int HASH_LEN = 128;
    char out[HASH_LEN];

    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    EVP_CipherInit_ex(ctx, EVP_rc4(), NULL, KEY, NULL, 1);
    EVP_CipherUpdate(ctx,out, &HASH_LEN, data, HASH_LEN);

    EVP_CIPHER_CTX_free(ctx);

    char *res = malloc(HASH_LEN);
    memcpy(res, out, HASH_LEN);
	return res;
}

char* get_token() {
	char *token = malloc(TOKEN_LEN);
	RAND_bytes(token, TOKEN_LEN);
	return token;
}

//User utilities
user* CONNECTED_USER[0xff];
user* REGISTERED_USER[0xff];
int registered = 0;
int connected = 0;

void print_u(user *u) {
	char *hex_pass = hexstr(u->password, strlen(u->password));
	printf("[USER] %s\t| pass=%s\t| token=%s\n", u->username, hex_pass, u->token);
	free(hex_pass);
}

void add_u(char* username, char* password) {
	int i = 0;
	user *u = malloc(sizeof(user));
	strncpy(u->username, username, USERNAME_LEN);
	char *b_pass = bytes(password, strlen(password));
	if (b_pass != NULL) {
		strncpy(u->password, b_pass, strlen(password));
		free(b_pass);
	} else {
		perror("ERR : Could not parse password");
		exit(1);
	}
	u->token = NULL;
	u->services_avail[0] = CE_RANDOM_CORP;
	u->services_avail[1] = NEXTCLOUD;
	u->services_avail[2] = GITLAB;
	u->nb_serv = 3;
	
	REGISTERED_USER[registered] = u;
	registered++;
	print_u(u);
}

user* get_user(char* username) {
	int i = 0;
	user *u = NULL;
	while (u == NULL && i < registered) {
		if (!strcmp(REGISTERED_USER[i]->username, username)) {
			u = REGISTERED_USER[i];
		} else {
			i++;
		}
	}
	return u;
}

user* get_connected_user(char* username) {
	int i = 0;
	user *u = NULL;
	while (u == NULL && i < connected) {
		printf("%d) %s\n", i, CONNECTED_USER[i]->username);
		if (!strcmp(CONNECTED_USER[i]->username, username)) {
			u = CONNECTED_USER[i];
		} else {
			i++;
		}
	}
	return u;
}

char* connect_u(char *username, char* password) {
	char *res = NULL, *hex1, *hex2;
	user *u = get_user(username);

	if (u != NULL) {
		char *provided_h = hash(password, strlen(password));
		printf("Length %d\n", strlen(password));
		hex1 = hexstr(provided_h, strlen(u->password));
		hex2 = hexstr(u->password, strlen(u->password));

		if (!strcmp(hex1, hex2)) {
			if (u->token == NULL) {
				u->token = get_token();
				CONNECTED_USER[connected] = u;
				connected++;
			}
			char *tkn = hexstr(u->token, TOKEN_LEN);
			res = give_msg(tkn);
			free(tkn);
		} else {
			res = give_error(ERR_BAD_PASS);
		}

		free(hex1);
		free(hex2);
		free(provided_h);
		printf("%s connected.\n", username);
	} else {
		res = give_error(ERR_NO_USR);
	}

	return res;
}

char* disconnect_u(char *username) {
	char *res = NULL;
	user *u = get_connected_user(username);

	if (u != NULL) {
		if (u->token != NULL) {
			free(u->token);
			u->token = NULL;
			res = give_msg(SUC_USR_CON);
			connected--;
		} else {
			res = give_error(ERR_USR_DIS);
		}
	} else {
		res = give_error(ERR_USR_DIS);
	}

	return res;
}

char* service_str(service* srv, int nb_service) {
	char *res;
	if (nb_service > 0) {
		res = malloc(nb_service * (SERVICES_LEN + 2));
		int i = 0;
		const char srv_join[] = ", ";
		while(i < nb_service) {
			strcat(res, SERVICES[srv[i]]);
			if (i+1 != nb_service) {
				strcat(res, srv_join);
			} else {
				strcat(res, LN);
			}
			i++;
		}
	} else {
		res = "";
	}

	return res;
}

char* list_services(char *username, char* token) {
	char *res = NULL;
	user *u = get_connected_user(username);

	if (u != NULL) {
		if (u->token != NULL) {
			char *hex_tkn = hexstr(u->token, TOKEN_LEN);
			if (!strcmp(token, hex_tkn)) {
				free(hex_tkn);
				return service_str(u->services_avail, u->nb_serv);
			} else {
				free(hex_tkn);
				res = give_error(ERR_BAD_TOKN);
			}
		} else {
			res = give_error(ERR_USR_DIS);
		}
	} else {
		res = give_error(ERR_USR_DIS);
	}

	return res;
}

char* parse_command(char *buf) {
	const char delimiters[] = " :\n";

	//action user:password
	char *action = strtok(buf, delimiters);	
	if (!strcmp(action, ACTIONS[CONNECT])) {
		char *user = strtok(NULL, delimiters);
		if (user == NULL) {
			return give_error(ERR_TKN_USR);
		}
		char *passwd = strtok(NULL, delimiters);
		if (passwd == NULL) {
			return give_error(ERR_TKN_PASS);
		}

		return connect_u(user, passwd);
	} else if (!strcmp(action, ACTIONS[DISCONNECT])) {
		char *user = strtok(NULL, delimiters);
		if (user == NULL) {
			return give_error(ERR_TKN_USR);
		}
		return disconnect_u(user);
	} else if (!strcmp(action, ACTIONS[LIST])) {
		char *user = strtok(NULL, delimiters);
		if (user == NULL) {
			return give_error(ERR_TKN_USR);
		}
		char *token = strtok(NULL, delimiters);
		if (token == NULL) {
			return give_error(ERR_TKN_TOKN);
		}

		return list_services(user, token);
	} else {
		return give_error(ERR_UNK_ACT);
	}

	return give_error(ERR_UNK);
}

void parse_db(unsigned char *file_content) {
	const char delims[] = ":\n";
	char *username;
	char *password;
	printf("Reading %s\n", strtok(file_content, delims));
	int no_problem = 1;
	while (no_problem) {
		username = strtok(NULL, delims);
		if (username != NULL) {
			password = strtok(NULL, delims);
			if (password != NULL) {
				add_u(username, password);
			} else {
				no_problem = 0;			
			}
		} else {
			no_problem = 0;
		}
	}
}

//Start TCP server on specified port
int start_server(int port_number) {

	//Create the server socket
	int *serv_sock = malloc(sizeof(int));
	*serv_sock = socket(AF_INET, SOCK_STREAM, 0);
	if (serv_sock < 0) {
		perror("ERR : Could not open server socket");
		exit(1);
	}

	//Allow socket reuse for debugging
	int optval = 1;
	setsockopt(*serv_sock, SOL_SOCKET, SO_REUSEADDR, (const void *)&optval , sizeof(int));

	//Define server data
	struct sockaddr_in serveraddr;
	bzero((char *) &serveraddr, sizeof(serveraddr));
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_addr.s_addr = htonl(INADDR_ANY); //Get IP address
	serveraddr.sin_port = htons((unsigned short)port_number); //Choose port

	if (bind(*serv_sock, (struct sockaddr *) &serveraddr, sizeof(serveraddr)) < 0) {
		perror("ERR Could not bind");
		exit(1);
	}
	if (listen(*serv_sock, 64) < 0) {
		perror("ERR Could not listen");
		exit(1);
	}

	struct sockaddr_in client; /* client addr */
	struct hostent *client_infos; /* client host info */
	char buf[BUFSIZE]; /* message buffer */
	char *hostaddrp; /* dotted decimal host addr string */
	int c_len = sizeof(client);
	int conn;
	char *response;

	while (1) {

		//Wait for request
		conn = accept(*serv_sock, (struct sockaddr *) &client, &c_len);
		if (conn < 0) {
			perror("ERR Could not accept");
			exit(1);
		}

		// gethostbyaddr: determine who sent the message 
		client_infos = gethostbyaddr((const char *)&client.sin_addr.s_addr, sizeof(client.sin_addr.s_addr), AF_INET);
		if (client_infos == NULL) {
			perror("ERR Could not get host from addr");
			exit(1);
		}
		hostaddrp = inet_ntoa(client.sin_addr);
		if (hostaddrp == NULL) {
			perror("ERR Could not parse IP address\n");
			exit(1);
		}
		printf("New connection from %s (%s)\n", client_infos->h_name, hostaddrp);

		// read: read input string from the client
		bzero(buf, BUFSIZE);
		int n = read(conn, buf, BUFSIZE);
		if (n < 0)  {
			perror("ERROR reading from socket");
			exit(1);
		}

		response = parse_command(buf);
		n = write(conn, response, strlen(response));
		free(response);
		if (n < 0) {
			perror("ERR Could not write to socket");
			exit(1);
		}

		close(conn);
	}
}

//Check provided options
int parse_options(int key, char *arg, struct argp_state *state) {
	struct arguments *arguments = state->input;

	switch (key) {
		case 'p':
			arguments->port_number = atoi(arg);
			printf("%d\n", arguments->port_number);
			if (arguments->port_number <= 0 || arguments->port_number >= 65536) {
				argp_error(state, "You should specify a port between 0 and 65536 (excluded).\n");
			}
			break;

		case 'f':
			if (access(arg, F_OK) != -1) {
				arguments->db_file = arg;
			} else {
			    perror("File doesn't exists.");
			    exit(1);
			}
			break;
	}

	return 0;
}

int main(int argc, char **argv) {

	struct arguments arguments;
	arguments.port_number = 5000;
	arguments.db_file = NO_DB;

	struct argp argp = { options, parse_options };
	argp_parse(&argp, argc, argv, 0, 0, &arguments);

	printf("Starting server on port %d.\n", arguments.port_number);
	if (!strcmp(arguments.db_file, NO_DB)) {
		printf("Starting without DB.\n");
	} else {
		FILE *file_pointer = fopen(arguments.db_file, "r");

		//Get file size
		fseek(file_pointer, 0, SEEK_END);  
		long file_size = ftell(file_pointer);  

		//Allocate some memory to store the file data
		unsigned char *file_content = malloc(file_size);  

		//Go to start and read all the file content
		rewind(file_pointer);
		fread(file_content, 1, file_size, file_pointer);
		fclose(file_pointer);  
		parse_db(file_content);
		free(file_content);
	}

	return start_server(arguments.port_number);
}
