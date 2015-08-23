#
# Cookbook Name:: mysite_base
# Attributes:: default
#

override[:localegen][:lang] = ['en_US.UTF-8']

default[:mysite_base][:home] = File.expand_path('~')

default[:mysite_base][:scripts] = "#{node[:mysite_base][:home]}/scripts"

default[:mysite_base][:sites] = "#{node[:mysite_base][:home]}/sites"

default[:mysite_base][:user] = File.basename(File.expand_path('~'))

default[:mysite_base][:group] = File.basename(File.expand_path('~'))

default[:mysite_base][:chef_root] = File.absolute_path(File.dirname(__FILE__)+'../../../')

ubuntu_release = `lsb_release -a | awk '{print $2}'`

default[:mysite_base][:machine][:version] = ubuntu_release.split.last

default[:mysite_base][:packages] = ['subversion' ,'git' ,'git-flow','unzip','python-pip','python-setuptools','python-magic','dos2unix','ntp', 'curl']