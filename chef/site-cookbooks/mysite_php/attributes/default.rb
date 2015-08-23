#
# Cookbook Name:: mysite_php
# Attributes:: default
#

# ubuntu extensions_dirs
extensions_dirs = {}
extensions_dirs['trusty'] = '/usr/lib/php5/20121212'


default[:mysite_php][:extensions_dir] = extensions_dirs[ node[:mysite_base][:machine][:version] ]

default[:mysite_php][:directives] = {}

default[:mysite_php][:packages] = ["php5", "php5-dev", "make", "php-pear", "php5-curl", "php5-mysql", "php5-gd", "php5-mcrypt", "php5-mysqlnd", "php5-json", "php5-memcache", "php5-mongo"]