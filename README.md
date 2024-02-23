# Bloggers

## Setup

Pre-requisites:
* [Docker](https://docs.docker.com/desktop/mac/install/)

Run :
```
make first-run
```

> **NOTE:** If you end up needing to update the installed gems you won't be running bundle, you'll want to run `make build`. Using `bundle install` will appear to work, but it won't actually update the bundled gems for docker.

Now start the server:
```
make server
```

You should now have a local env with the following services:

- db : mysql database
- app : rails web app

## Development workflow

A common entry point to start developing is to run either `make server` or `make sh`, this runs all the services:

```
make sh
```

## Seeds

To reset your DB to what is in the seeds file, you can run `rake db:reset` or the following:

```
rake db:drop && rake db:create && rake db:schema:load && rake db:seed
```