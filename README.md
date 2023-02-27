# README

This README would normally document whatever steps are necessary to get the
application up and running.

### Development Environment Setup
- Download  [Docker](https://docs.docker.com/docker-for-mac/install/)
- Run `docker-compose up` - This will build the containers (for the first time)
- To run rails console - `docker-compose run rails-api rails c`
- Essentially to run any commands in the project root - `docker-compose run rails-api <command>`
- If you have made changes to the environment - Added gems, or installed other dependencies like yarn, make sure you rebuild the app container by calling `docker-compose build`
- This uses redis to save the packages, no datbase needed.

### Testing
- Rails - Run Test:
	- `docker-compose run rails-api rspec`


## APIs
- API to get all available packages in redis 
     GET - http://localhost:3000/api/v1/packages
- API to create parse and update the CRAN packages
     POST - http://localhost:3000/api/v1/packages
- Cron job will run every day which will update the packages from CRAN server
   To do that:  
    $ crontab -e
	This will open the crontab file in the default editor. Add the following line to the file to run the indexer script every day at midnight:

	bash
	Copy code
	0 0 * * * /usr/bin/ruby /path/to/schedule.rb
	Make sure to replace `/path/to
