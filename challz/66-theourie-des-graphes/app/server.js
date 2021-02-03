var express = require("express");
var { graphqlHTTP } = require("express-graphql");
var { buildSchema } = require("graphql");

var schema = buildSchema(`
    type Query {
        Intro: String
        GetCourse(id: ID!): Course
        GetAllCourses: [Course]
    }

    type Course {
        id: ID!
        title: String
        content: String
        published: Boolean
    }
`);

class Course {
    constructor(id, title, content, published) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.published = published;
    }
}

var courses = [];
for(i=0; i<137; i++) {
    courses[i] = new Course(i, "Cours " + i, "La théorie des graphes est la discipline mathématique et informatique qui étudie les graphes, lesquels sont des modèles abstraits de dessins de réseaux reliant des objets1. Ces modèles sont constitués par la donnée de sommets (aussi appelés nœuds ou points, en référence aux polyèdres), et d'arêtes (aussi appelées liens ou lignes) entre ces sommets ; ces arêtes sont parfois non-symétriques (les graphes sont alors dits orientés) et sont appelés des flèches. - Wikipedia", true);
}
courses[69] = new Course(24, "Note pour moi", "TODO: finir de migrer les notes de /secret_notes", false);

var root = {
    Intro: () => {
        return "C'est ici que je répertorie mes notes sur les différentes théories mathématiques. N'hésitez pas à fouiller un peu pour trouver votre bonheur. Le site est encore enconstruction et certaines notes sont en cours de rédaction, vous n'y avez pas encore accès.";
    },
    GetCourse: (id) => {
        return courses[id['id']];
    },
    GetAllCourses: () => {
        tmp = [];
        for(i=0; i<courses.length; i++) {
            if(courses[i]["published"] === true) {
                tmp.push(courses[i]);
            }
        }
        return tmp;
    },
};

var app = express();

app.get("/", (req, res) => {
    res.send("Pour la liste de mes cours, visitez /graphql !");
});

app.get("/secret_notes", (req, res) => {
    result = [];
    for(i=0; i<69; i++) {
        result.push(`# Note en rédaction
Plusieurs arguments prétendument scientifiques s’opposent aux versions « officielles ». La platitude de l’horizon, par exemple, soulève plusieurs questions : l’œil humain voit cet horizon plat et droit, sans courbure, même sur une mer à perte de vue. Il s’agirait là d’un premier indice incohérent avec la théorie d’une planète sphérique. Sont également soulignées les prises de vue faites par des ballons météorologiques à plus de 30km d’altitude qui témoignent d’un horizon tout aussi plat.`);
    }
    result[5] = `# Liste de courses
* liqueur de café
* triple sec
* amareto
* jus d'ananas
* sandwich triangle`;
    result[13] = `# Important
Il faut finir ce challenge pour le CTF InterIUT, même si les joueurs ne termineront pas tous les challenges.`;
    result[33] = `# Important
J'espère pouvoir terminer ce challenge pour le jour J, ce foutu corona qui m'empêche d'aller aux caraïbes.
D'ailleurs il faut utiliser H2G2{gr4phQl_1s_c0oL_riGHt?} pour valider le challenge. Après je ne sais pas si c'est une bonne idée de mettre un flag comme ça pour un challenge comme ça ; après tout ne faudrait-il pas focaliser son attention sur le reverse ou le pwn ? Encore un débat à débattre.`;
    res.send(result.join("\n"));
});

app.use("/graphql", graphqlHTTP({
    schema: schema,
    rootValue: root,
    graphiql: true,
}));

app.listen(80);
console.log("Running!");
