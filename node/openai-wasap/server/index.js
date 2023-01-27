import dotenv from 'dotenv'
import { Configuration, OpenAIApi } from 'openai'
import { createRequire } from 'module';

dotenv.config()

const require = createRequire(import.meta.url);
const qrcode = require('qrcode-terminal');

const { Client, LocalAuth } = require('whatsapp-web.js');

const client = new Client({
    authStrategy: new LocalAuth()
});

client.on('qr', qr => {
  qrcode.generate(qr, {small: true});
});


client.on('ready', () => {
  console.log('Client is ready!');
});

client.on('message', message => {
	console.log(message.body);
});

const servidor = process.env.VITE_IP;

const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});

const openai = new OpenAIApi(configuration);

client.on('message', async message => {
  if (message.body.startsWith('Juan ')) {
    const response = await openai.createCompletion({
    model: "text-davinci-003",
    prompt: `${message.body}`,
    temperature: 0, // Higher values means the model will take more risks.
    max_tokens: 3000, // The maximum number of tokens to generate in the completion. Most models have a context length of 2048 tokens (except for the newest models, which support 4096).
    top_p: 1, // alternative to sampling with temperature, called nucleus sampling
    frequency_penalty: 0.5, // Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    presence_penalty: 0, // Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    });
    client.sendMessage(message.from, response.data.choices[0].text.trim())
  }
});

client.initialize();