#
# Cookbook Name:: mysite_newrelic
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


license = data_bag_item("newrelic", "license")

node.override['newrelic']['license'] = license["key"]
node.override['newrelic']['server_monitoring']['license'] = license["key"]

include_recipe 'newrelic'
include_recipe 'newrelic::php-agent'