#
# Cookbook Name:: mysite_base
# Recipe:: default
#
#

# include recipe
include_recipe 'apt'
include_recipe 'java'

# configure locals (en_US.UTF-8)
include_recipe 'locale-gen'


# setup bash profile bin folder
remote_directory "#{node[:mysite_base][:home]}/bin" do
	files_mode '644'
	files_owner node[:mysite_base][:user]
	mode '755'
	owner node[:mysite_base][:user]
	source "bin"
end


# machine ".bash_profile" file.
cookbook_file "/tmp/bash_profile" do
	source "bash_profile"
end

bash "append_to_bash_profile" do
	user "root"
	code <<-EOF
	  cat ~/.bash_profile >> /tmp/bash_profile
	  mv /tmp/bash_profile ~/.bash_profile
	EOF
end


# setup scripts folder
directory "#{node[:mysite_base][:scripts]}" do
	owner node[:mysite_base][:user]
	group node[:mysite_base][:group]
	mode '0755'
end


# setup shell utils folder
remote_directory "#{node[:mysite_base][:scripts]}/shellutils" do
	files_mode '0755'
	files_owner node[:mysite_base][:user]
	mode '0755'
	owner node[:mysite_base][:user]
	source "shellutils"
end

# install base packages
node[:mysite_base][:packages].each do |p|
  package p
end




