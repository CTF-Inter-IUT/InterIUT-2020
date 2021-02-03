import { Request, Response } from 'express';
import { v4 as uuid } from 'uuid';
import { IMessage } from './IMessage';
import { History } from './History';

export class DioController {

    private static famousLines: string[] = [
        'It was Me, Dio !',
        'How many breads have you eaten in your life?',
        'Muda! Muda! Muda! Muda! Muda!',
        'Za warudo!',
        'I\'m number one!',
        'GOODBYE, JOJO!',
        'You made the wrong move, you stupid pig!',
        'I\'m throwing away my humanity, JoJo !'
    ];

    public static async sayHey(req: Request, res: Response) {
        try {
            let userId: string;
    
            if (req.body.userId && !['undefined', 'null'].includes(req.body.userId)) {
                userId = req.body.userId;

                res.send({
                    userId,
                    history: await History.getHistroy(userId)
                });
    
            } else {
                userId = uuid();
    
                const message: IMessage = {
                    userId,
                    message: DioController.famousLines[Math.floor(Math.random() * DioController.famousLines.length)],
                    fromDio: true
                };
    
                res.send({
                    userId,
                    history: [await History.saveMessage(message)]
                });
            }
        } catch (exception) {
            console.error(exception);
        }
    }

    public static async postMessage(req: Request, res: Response) {
        try {
            
            if (!req.body.userId) {
                return res.sendStatus(401);
            }
    
            if (!req.body.message) {
                console.log(req.body);
                return res.sendStatus(400);
            }
    
            History.saveMessage({
                userId: req.body.userId,
                message: req.body.message,
                fromDio: false
            });
    
            const message: IMessage = {
                userId: req.body.userId,
                message: DioController.famousLines[Math.floor(Math.random() * DioController.famousLines.length)],
                fromDio: true
            };
            
            await new Promise(resolve => setTimeout(resolve, 1e3));

            res.send({
                reply: await History.saveMessage(message)
            });

        } catch (exception) {
            console.error(exception);
        }
    }

}
