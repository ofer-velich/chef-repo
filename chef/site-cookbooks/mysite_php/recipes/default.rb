#
# Cookbook Name:: mysite_php
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# install mysite_php packages
# -------------------------------------
node[:mysite_php][:packages].each do |p|
  package p
end


# install php apache ini
# -------------------------------------
template '/etc/php5/apache2/php.ini' do
	source 'apache2/php.ini.erb'
	owner 'root'
    group 'root'
	action :create
end

# install php cli ini
# -------------------------------------
template '/etc/php5/cli/php.ini' do
	source 'cli/php.ini.erb'
	owner 'root'
    group 'root'
	action :create
end


# install php opcache ini
# -------------------------------------
template '/etc/php5/mods-available/opcache.ini' do
	source 'opcache.ini.erb'
	owner 'root'
    group 'root'
	action :create
end


# enable the opcache module
# -------------------------------------
execute "enable opcache" do
	user "root"
	command "php5enmod opcache"
end


# enable the mcrypt module
# -------------------------------------
execute "enable mcrypt" do
	user "root"
	command "php5enmod mcrypt"
	only_if { node[:mysite_base][:machine][:version] == 'trusty' }
end
