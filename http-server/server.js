import express from 'express'

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

  var items = data.api
              .concat(data.web)
              .concat(data.hooks)
              .concat(data.git)
              .concat(data.pages)
              .concat(data.importer)
              .concat(data.actions)
              .concat(data.dependabot)
              .concat(data.packages)
              .sort();
  
  res.send(Array.from(new Set(items))  );
})

app.listen(port, () => {
  console.log(`App listening on port ${port}`)
})