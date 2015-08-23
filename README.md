### bootstrap image:
```
#!/bin/bash

sudo apt-get install git

gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

\curl -sSL https://get.rvm.io | bash -s stable --ruby

source /home/ubuntu/.rvm/scripts/rvm

gem install bundler

gem install berkshelf

gem install knife-solo

curl -L https://www.opscode.com/chef/install.sh | sudo bash
```
