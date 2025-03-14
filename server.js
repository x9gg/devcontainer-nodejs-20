import Fastify from 'fastify';
import fastifyView from '@fastify/view';
import ejs from 'ejs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const fastify = Fastify({ logger: true });

fastify.register(fastifyView, {
  engine: { ejs },
  root: path.join(__dirname, 'views'),
});

fastify.get('/', async (request, reply) => {
  return reply.view('index.ejs', { 
    title: 'Hello world, it works!',
    nodeVersion: process.version.slice(1),
    fastifyVersion: fastify.version
  });
});

const start = async () => {
  try {
    await fastify.listen({ port: 3000, host: '0.0.0.0' });
    console.log('Server running at http://0.0.0.0:3000');
  } catch (err) {
    fastify.log.error(err); 
    process.exit(1);
  }
};

start();
