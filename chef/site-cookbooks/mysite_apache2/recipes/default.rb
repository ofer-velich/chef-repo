#
# Cookbook Name:: mysite_apache2
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# install mysite_apache2 packages
# -------------------------------------
node[:mysite_apache2][:packages].each do |p|
  package p
end

# install mysite_apache2 modules
# -------------------------------------
node[:mysite_apache2][:modules].each do |m|
	execute "sudo a2enmod #{m}"
end



# setup scripts apache2 folder
directory "#{node[:mysite_base][:scripts]}/apache2" do
	owner node[:mysite_base][:user]
	group node[:mysite_base][:group]
	mode '0755'
end

# setup maintenance script
# -------------------------------------
cookbook_file "#{node[:mysite_base][:scripts]}/apache2/maintenance.sh" do
	source "maintenance.sh"
	owner node[:mysite_base][:user]
	group node[:mysite_base][:user]
	mode '0755'
end

# setup site healthcheck scripts folder
# -------------------------------------
remote_directory "#{node[:mysite_base][:scripts]}/sites/healthcheck" do
	files_mode '0755'
	files_owner node[:mysite_base][:user]
	mode '0755'
	owner node[:mysite_base][:user]
	source "healthcheck"
end

# setup site healthcheck
# -------------------------------------
directory "#{node[:mysite_base][:sites]}/healthcheck" do
	owner node[:mysite_base][:user]
	group node[:mysite_base][:group]
	mode '0755'
end

template "#{node[:mysite_base][:sites]}/healthcheck/index.html" do
	source "healthcheck.html.erb"
	owner node[:mysite_base][:user]
	group node[:mysite_base][:user]
	mode '0755'
end

template "/etc/apache2/sites-available/healthcheck.conf" do
	source "healthcheck.conf.erb"
	owner "root"
	group "root"
	mode '644'
end

# enable the healthcheck site
# -------------------------------------
execute "a2ensite healthcheck.conf" do
	user "root"
end

# disable the default site
# -------------------------------------
execute "a2dissite 000-default.conf" do
	user "root"
	only_if { node.chef_environment == "production" }
end

# apache restart ...
# -------------------------------------
#execute "service apache2 restart" do
#	user "root"
#end
service "apache2" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
