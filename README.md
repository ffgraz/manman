# manman

# Setting up your dev environment

Required software on host:
- vagrant
- virtualbox
- docker
- mysql

A copy of the manman database is required aswell as mysql socket exposed under /run/mysqld and a manman user. Adjust the socket location and password in `./run` before attempting to start manman

First vagrant VM needs to be bootstrapped or started via `vagrant up`

Then `./dev` can be used to build the image in vagrant docker, pull it on the host and start it locally as http://localhost:3000

The image runs in such a way that the most of the rails files are loaded directly from the repo folder instead of the image. Meaning any change will be immidietly visible after reloading.

# Publishing

First run `./dev` which will rebuild everything and test under http://localhost:3000 that all is well

Then run `./push` (you can adjust the push location to a different address, @mkg20001 can be contacted to pull and push the image into the right location)
