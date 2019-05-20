# smb-lead-generator #
A tool to search the web for small business contact information. Contains 2 servers: The crawler server and the front-end. There is currently no indexer and the crawler sends the results as they are found.
![frontend](https://bytebucket.org/dan-velez/smb-lead-generator/raw/1eedd22f7a8764c3ecdccb1fc7be50ad8224c05e/images/frontend.png)

## Installation ##
There are 2 servers on this repository. One is the actual web crawling service, the other is the server for the web interface. Both the servers run on coffeescript/node.js.

### web-crawlers ###
```
# First install all the necessary packages, along with coffeescript.
$ cd web-crawlers/
$ sudo npm i -g iced-coffee-script
$ npm i

# Run in foreground
$ iced server.iced

# Run as a background daemon attached to the terminal
$ iced server.iced &

# Run as an unattended daemon
$ nohup iced server.iced &
```

### web-app ###
```
# First install all the necessary packages, along with coffeescript.
$ cd web-app/

# If coffee-script isn't already installed...
$ npm i -g iced-coffee-script

$ npm i

# Run in foreground
$ iced srv/server.main.iced

# Run as a background daemon attached to the terminal
$ iced srv/server.main.iced &

# Run as an unattended daemon
$ nohup srv/iced server.main.iced &

# Open browser to localhost:5000
```


## Usage ##
### Web Interface ###
The web app allows the user to run customized searches by the bots, and provides an output console to view the status of the bot.

### CLI ###
You can also use a CLI to get the contact information on the CLI or printed to a .csv file.
```
# Here is an example with the http://allbiz.com crawler.
$ cd web-crawlers/
$ iced all-biz/allbiz-crawler.iced
```


## Extending ##
### Adding a New Crawler ###
It is possible to add a new website to the crawler with minimal code. Create a new file in the web-crawlers/ directory. Relative the web crawling libray.
```coffeescript
crawler = require 'iced-crawler'

runner = # Controls the flow of the crawler.
	run: false
    
iced-crawler.bfs
	root: 'http://twitter.com'
    path: '/'
    visit: ({ root, path })-> console.log 'visiting', path
    running: runner.run # Switch off to stop crawling.
    linkP: (link)-> link? and link.includes 'tweet'
    done: ->

crawler.bfs({ root, path, visit, running, done, linkP })
# root    - the domain to crawl. 
# path    - the starting point in the domain to crawl.
# visit   - a function to run on each visited link.
# running - a structure to control the flow of the function.
# done    - a callback to run after search is exhausted.
# linkP   - link predicate. Run on each link and return true to follow.
```

### Adding a New Crawler (GUI) ###
Edit the following files to have the crawler show up as an option in the GUI.

1. `route.lead-search.iced` in class RouteLeadSearch, add name to state.sources
   Name must match that in ebizfi-crawlerserver

2. `route.lead-search.iced` Add an entry to structure in function `setCrawlers`
   Add a validation function if necessary. match packet to the server programs input

3. `view.lead-search-controls.iced` Add the name under the approriate controls, or create a new statement which includes this crawler.


## Available Crawlers ##
https://bbb.org

https://truckingdatabase.com

https://yellowpages.com

https://spoke.com

https://google.com

https://brownbook.com

https://ezlocal.com

https://chamberofcommerce.com

https://all-contractors.com

https://all-biz.com
