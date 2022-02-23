const applicationOne = require('./appOne')

process.on("SIGTERM",()=>{
        debug('SIGTERM signal received: closing HTTP server')
        applicationOne.close(() => {
                debug('HTTP server closed')
        })
})