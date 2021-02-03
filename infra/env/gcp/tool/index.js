const path = require('path');
const fs = require('fs');
const proc = require('child_process');
const rimraf = require('rimraf');
const { program } = require('commander');
const { default: Axios } = require('axios');
const AdmZip = require('adm-zip');

const root = path.resolve(__dirname, '..');
const outputTeams = path.join(root, 'teams');
let existingTeams;

try {
    existingTeams = require(path.join(root, 'output_namespaces.json'));
    
} catch (error) {
    existingTeams = [];
}

console.log({ root, outputTeams });

program.command('genteam')
    .action(() => {
        rimraf.sync(outputTeams);
        fs.mkdirSync(outputTeams);

        const config = [
            genNamespace(require(path.join(root, 'input_teams.json')), 0),
            genNamespace(require(path.join(root, 'input_special_teams.json')), 1)
        ];

        fs.writeFileSync(
            './output_namespaces.json',
            JSON.stringify(config, null, 2),
            { encoding: 'utf-8' }
        );
    });







const genKeyPair = () => {
    const private = proc.execSync('wg genkey').toString('utf-8').replace('\n', '');
    const public = proc.execSync(`echo ${private} | wg pubkey`).toString('utf-8').replace('\n', '');
    
    return [ private, public ];
}

const genNamespace = (teams, nsIndex) => {
    const [ serverPrivate, serverPublic ] = existingTeams[nsIndex]
        ? [existingTeams[nsIndex].wg.private, existingTeams[nsIndex].wg.public]
        : genKeyPair();

    const port = 51000 + nsIndex;
    let internalIp = 10;
    const config = {
        wg: { private: serverPrivate, public: serverPublic, port },
        teams: teams.map((team, index) => {
            const existingTeam = existingTeams[nsIndex]?.teams.find(eTeam => eTeam.name === team.name);
            
            const zip = new AdmZip();

            // fs.mkdirSync(path.join(__dirname, 'teams', team.name));
            const clientsKeyPair = team.members.map(member => {
                const exist =  existingTeam?.members.find(existingMember => member.name === existingMember.name);
                if (exist) {
                    return [ exist.wg.private, exist.wg.public ];
                }
                return genKeyPair();
            });

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
    Address = 10.8.${8 + Math.floor(internalIp / 253)}.${internalIp % 253 + 1}/32
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
    AllowedIPs = 10.8.8.1/32, 10.3.0.0/16
    # Et pour finir, le keepalive pour éviter d'avoir des soucis
    # si le client se trouve derrière un routeur NAT
    PersistentKeepalive = 25
    `

                        }
                    };
                    
                    zip.addFile(`${path.normalize(team.members[index].name)}.conf`, Buffer.from(data.wg.configFile));

                    return data
                })
            };

            zip.writeZip(path.join(outputTeams, path.normalize(team.name)) + '.zip');

            return data;
        })
    };

    config.wg.configFile = `
# ==== Configurations du serveur ====

[Interface]
# Adresse IP du serveur à l'intérieur du VPN
Address = 10.8.8.1/16
# Clef privée du serveur
PrivateKey = ${config.wg.private}
# Port sur lequel le serveur écoute
ListenPort = 51820

# On exécute les commandes d'ajout des règles lorsque le VPN démarre
PostUp = iptables -A FORWARD -i %i -j ACCEPT ; iptables -A FORWARD -o %i -j ACCEPT ; iptables -t nat -A POSTROUTING -s 10.8.8.0/16 -o eth0 -j MASQUERADE

# Et on rajoute des commandes pour les supprimer lorsque le VPN est éteint
PostDown = iptables -D FORWARD -i %i -j ACCEPT ; iptables -D FORWARD -o %i -j ACCEPT ; iptables -t nat -D POSTROUTING -s 10.8.8.0/16 -o eth0 -j MASQUERADE




` + config.teams.map(team => `
# Team : ${team.name}

` + team.members.map(member => `
[Peer]
# ${member.name}
PublicKey = ${member.wg.public}
AllowedIPs = 10.8.${8 + Math.floor(member.wg.internalIp / 253)}.${member.wg.internalIp % 253 + 1}/32
`).join('\n')

).join('\n');
    
    return config;
}

program.parse(process.argv);
