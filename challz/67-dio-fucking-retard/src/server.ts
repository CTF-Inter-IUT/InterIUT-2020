import path from 'path';
import express from 'express';
import bodyParser from 'body-parser';
import { DioController } from './DioController';

const app = express();

app.use(bodyParser.json());

app.use(express.static(path.resolve(__dirname, '..', 'public')));

app.post('/hey', DioController.sayHey);
app.post('/message', DioController.postMessage);

app.listen(80, () => console.log('Dio\'s chat started on port 3000'));