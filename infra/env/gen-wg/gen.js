const proc = require('child_process');
const fs = require('fs');
const path = require('path');

const teams = require('./teams.json');

console.log(teams.length);

fs.mkdirSync(path.join(__dirname, 'teams'));

const splitChunks = (teams, size) => {
    const namespaces = [];

    for (let i = 0; i < teams.length; i += size) {
        namespaces.push(teams.slice(i, i + size));
    }

    return namespaces;
}

const genKeyPair = () => {
    const private = proc.execSync('wg genkey').toString('utf-8').replace('\n', '');
    const public = proc.execSync(`echo ${private} | wg pubkey`).toString('utf-8').replace('\n', '');
    
    return [ private, public ];
}

const genNamespace = (teams, index) => {
    const [ serverPrivate, serverPublic ] = genKeyPair();

    const port = 51000 + index;
    let internalIp = 10;

    return {
        wg: { private: serverPrivate, public: serverPublic, port },
        teams: teams.map((team, index) => {
            fs.mkdirSync(path.join(__dirname, 'teams', team.name));
            const clientsKeyPair = team.members.map(genKeyPair);

            let data = {
                ...teams[index],
                members: clientsKeyPair.map(([private, public], index) => {
                    
                    let data = {
                        ...team.members[index],
                        wg: {
                            private,
                            public,
                            internalIp: ++internalIp,
                            configFile: `
    [Interface]
    # Adresse IP du client à l'intérieur du VPN
    Address = 10.8.8.${internalIp}/24
    # Clef privée du client
    PrivateKey = ${private}
    DNS = 10.8.8.1

    # ==== Configuration liée au serveur ====

    [Peer]
    # Clef publique du du serveur
    PublicKey = ${serverPublic}
    # Adresse et port du serveur
    Endpoint = 34.78.23.38:${port}
    # Range d'adresses IP qui doivent être routées à travers le VPN
    AllowedIPs = 10.8.8.0/24, 10.3.0.0/16
    # Et pour finir, le keepalive pour éviter d'avoir des soucis
    # si le client se trouve derrière un routeur NAT
    PersistentKeepalive = 25
    `

                        }
                    };
                    
                    fs.writeFileSync(path.join(__dirname, 'teams', team.name, team.members[index].name + '.conf'), data.wg.configFile)
                    
                    return data
                })
            };

            return data;
        })
    };
}


const main = () => {
    let namespaces = splitChunks(teams, 7);

    namespaces = namespaces.map(genNamespace);

    for (const ns of namespaces) {
        ns.wg.configFile = `
# ==== Configurations du serveur ====

[Interface]
# Adresse IP du serveur à l'intérieur du VPN
Address = 10.8.8.1/24
# Clef privée du serveur
PrivateKey = ${ns.wg.private}
# Port sur lequel le serveur écoute
ListenPort = 51820

# On exécute les commandes d'ajout des règles lorsque le VPN démarre
PostUp = iptables -A FORWARD -i %i -j ACCEPT ; iptables -A FORWARD -o %i -j ACCEPT ; iptables -t nat -A POSTROUTING -s 10.8.8.0/24 -o eth0 -j MASQUERADE

# Et on rajoute des commandes pour les supprimer lorsque le VPN est éteint
PostDown = iptables -D FORWARD -i %i -j ACCEPT ; iptables -D FORWARD -o %i -j ACCEPT ; iptables -t nat -D POSTROUTING -s 10.8.8.0/24 -o eth0 -j MASQUERADE




` + ns.teams.map(team => `
# Team : ${team.name}

` + team.members.map(member => `
[Peer]
# ${member.name}
PublicKey = ${member.wg.public}
AllowedIPs = 10.8.8.${member.wg.internalIp}/32
`)

);
    }

    return namespaces;
}

const config = main();
fs.writeFileSync('./nice_teams.json', JSON.stringify(config, null, 2), { encoding: 'utf-8' });