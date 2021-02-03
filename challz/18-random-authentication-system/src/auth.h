#ifndef _RANDOM_AUTH_H_
#define _RANDOM_AUTH_H_ 1

#define TOKEN_LEN 16
#define USERNAME_LEN 20
#define PASS_LEN 64

#define SERVICES_LEN 15
#define ACTIONS_LEN 12

const char KEY[TOKEN_LEN] = "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f";

const char ERR_HDR[] = "ERR ";
const char ERR_TKN_USR[] = "Can't get user.";
const char ERR_TKN_PASS[] = "Can't get password.";
const char ERR_TKN_TOKN[] = "Can't get token.";
const char ERR_UNK_ACT[] = "Action doesn't exists";
const char ERR_UNK[] = "Unknown error.";
const char ERR_NO_USR[] = "User doesn't exists.";
const char ERR_BAD_PASS[] = "Bad password.";
const char ERR_USR_DIS[] = "User is not connected.";
const char SUC_USR_CON[] = "User got disconnected.";
const char ERR_BAD_TOKN[] = "Bad token.";

typedef enum service {
	NEXTCLOUD = 0,
	GITLAB = 1,
	JIRA = 2,
	JENKINS = 3,
	SONARQUBE = 4,
	ODOO = 5,
	CE_RANDOM_CORP = 6
} service;

const char SERVICES[7][SERVICES_LEN] = {
	"Nextcloud",
	"Gitlab",
	"Jira",
	"Jenkins",
	"SonarQube",
	"Odoo",
	"Site du CE"
};

typedef struct tmp_user
{
	char username[USERNAME_LEN];
	char password[PASS_LEN];
	char* token;
	int nb_serv;
 	service services_avail[7]; //Total number
 	struct tmp_user* next;
} user;

typedef enum action {
	CONNECT = 0,
	DISCONNECT = 1,
	LIST = 2
} action;

const char ACTIONS[3][ACTIONS_LEN] = {
	"connect",
	"disconnect",
	"list"
};

/**
* Check the user password and give him his token if the password is correct
* returns a token or the error to send to the user
*/
char* connect_u(char *username, char *password);

char* disconnect_u(char *username);

char* hash(char* data, int data_len);

service* list_avail_services(char *username, char *token);

/**
* returns success/error code
*/
int import_db(char *filename);

#endif /* _RANDOM_AUTH_H_ */