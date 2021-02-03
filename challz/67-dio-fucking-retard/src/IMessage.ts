import { ObjectId } from "mongodb";

export interface IMessage {
    _id?: ObjectId;
    userId: string;
    message: string;
    fromDio: boolean;
}