import express from 'express'
import jq from 'node-jq'
import fetch from 'node-fetch'


const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

async function getData(url) {
  try {
    const response = await fetch(url);
    const json = await response.json();
    return json;
  } catch (error) {
    console.log(error);
  }
};

app.get('/ip/github', async (req, res) => {

    var data = await getData("https://api.github.com/meta");
    const filter = '.api[]'
    const jsonPath = '/path/to/bulbasaur.json'
    const options = {}
    
    var output = await jq.run(filter, data, { input: 'json' });
    res.header("Content-Type",'text/plain');
    res.send(output);
  })
  

app.listen(port, () => {
  console.log(`App listening on port ${port}`)
})