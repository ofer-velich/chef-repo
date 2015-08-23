#
# Cookbook Name:: mysite_apache2
# Attributes:: default
#

default[:mysite_apache2][:packages] = ["apache2", "libapache2-mod-auth-mysql"]
default[:mysite_apache2][:modules] = ["rewrite", "ssl", "headers", "expires"]