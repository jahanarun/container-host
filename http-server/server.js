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

async function getDnsAnswer(domain) {
  let response = await fetch(`https://dns.google/resolve?name=${domain}&type=A`)
  let data = await response.json();
  var result = data.Answer.map(answer => answer.data);
  return result;
}

async function getStackOverflowUrls() {
  return await getDnsAnswer('stackoverflow.com');
}

app.get('/ip/all', async (req, res) => {
  var githubUrls = await getGithubUrls();

  var stackoverflowUrls = await getStackOverflowUrls();
  var result = githubUrls.concat(stackoverflowUrls);
  res.contentType('text');
  res.send(Array.from(new Set(result)).join("\n"));
})


async function getGithubUrls() {
  var data = await getData("https://api.github.com/meta");

  return data.api
    .concat(data.web)
    .concat(data.hooks)
    .concat(data.git)
    .concat(data.pages)
    .concat(data.importer)
    .concat(data.actions)
    .concat(data.dependabot)
    .concat(data.packages)
    .sort();
}

app.get('/ip/github', async (req, res) => {
  var items = await getGithubUrls();
  res.contentType('text');
  res.send(Array.from(new Set(items)).join("\n"));
})

app.listen(port, () => {
  console.log(`App listening on port ${port}`)
})