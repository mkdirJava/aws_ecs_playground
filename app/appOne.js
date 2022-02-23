const express = require('express')
const bodyParser = require('body-parser')
const app = express()

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

const mapOfIpToPayload = {}
const port = process.env.PORT || 7070


app.get('/data',(request,response)=>{
        response.send(`All of the submitted data 
        ${JSON.stringify(mapOfIpToPayload)}
        `)
});

app.get('/data/:ip',(request,response)=>{
        if (!request.params.ip && !mapOfIpToPayload.get(request.params.ip)){
                response.send('No data posted, you may want to post to /data with a request body')
                return;
        }
        response.send(`I am a response from the application ${JSON.stringify(request.ip)}`)
});
app.post('/data',(request,response)=>{
        if(!request.body){
                response.send('No data posted, you may want to post to /data with a request body')
                return
        }
        mapOfIpToPayload[request.ip] =  request.body
        response.send('Added data')
})

const server = app.listen(port,()=> console.log(`Started server at ${port}`));

module.exports = server