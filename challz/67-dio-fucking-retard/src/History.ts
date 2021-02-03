import { MongoClient, Collection } from 'mongodb';
import { IMessage } from './IMessage';

MongoClient.connect('mongodb://127.0.0.1', {
        auth: {
            user: 'challenge',
            password: 'jd4nN2dcXkfJrXaEeJC8m3rZZBPSDL77'
        },
        useUnifiedTopology: true,
        useNewUrlParser: true
    }, (err, db) => {
    if (err) {
        console.error(err);
    } else {
        console.log('Connected to database');
        History.collection = db.db('DioChat').collection('messages');

        History.collection.deleteMany({});

        History.collection.insertOne({
            userId: 'j0hn474n-j03574r',
            message: 'H2G2{k0n0_d10_d4_!}',
            fromDio: true
        });
    }
});

export class History {

    public static collection: Collection<IMessage>;

    public static async getHistroy(userId: string): Promise<IMessage[]> {
        return History.collection.find({
            userId
        }).toArray();
    }

    public static async saveMessage(message: IMessage): Promise<IMessage> {
        message._id = (await History.collection.insertOne(message)).insertedId;
        return message;
    }

}
