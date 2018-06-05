import './main.css';
import { Main } from './Main.elm';

// Main.embed(document.getElementById('root'));
Main.embed(document.getElementById('root'), {
  api_url: process.env.ELM_APP_API_URL,
});
