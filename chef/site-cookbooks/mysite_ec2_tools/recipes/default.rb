#
# Cookbook Name:: mysite_ec2_tools
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

access = data_bag_item("aws", "access")
secret = data_bag_item("aws", "secret")

node.default[:mysite_ec2_tools][:access_key] = access["key"]
node.default[:mysite_ec2_tools][:secret_key] = secret["key"]


# setup aws config files
# -------------------------------------

template "#{node[:mysite_base][:home]}/.s3cfg" do
  source "s3cfg.erb"
  owner node[:mysite_base][:user]
  group node[:mysite_base][:user]
  mode '0644'
end

directory "#{node[:mysite_base][:home]}/.aws" do
  owner node[:mysite_base][:user]
  group node[:mysite_base][:user]
  mode '755'
  action :create
end

template "#{node[:mysite_base][:home]}/.aws/config" do
  source "aws.config.erb"
  owner node[:mysite_base][:user]
  group node[:mysite_base][:user]
  mode '0644'
end

template "#{node[:mysite_base][:home]}/.aws/.awstoolscredentials" do
  source "aws.awstoolscredentials.erb"
  owner node[:mysite_base][:user]
  group node[:mysite_base][:user]
  mode '0644'
end


# setup aws envrioment vars
# -------------------------------------

ruby_block "setup_aws_env_vars" do
  block do
    file = Chef::Util::FileEdit.new("#{node[:mysite_base][:home]}/bin/exports.sh")
    file.insert_line_if_no_match("/export AWS_ACCESS_KEY_ID=/", "export AWS_ACCESS_KEY_ID=#{access['key']}")
    file.insert_line_if_no_match("/export AWS_SECRET_ACCESS_KEY=/", "export AWS_SECRET_ACCESS_KEY=#{secret['key']}")
    file.insert_line_if_no_match("/export AWS_CREDENTIAL_FILE=/", "export AWS_CREDENTIAL_FILE=~/.aws/.awstoolscredentials")
    file.insert_line_if_no_match("/export AWS_SECRET_ACCESS_KEY=/", "export AWS_CONFIG_FILE=~/.aws/config")
    file.write_file
  end
end


# install ec2 packages
# -------------------------------------

node[:mysite_ec2_tools][:packages].each do |p|
  package p
end


# install ec2 cli tools
# -------------------------------------
execute "install_awscli" do
  user "root"
  command "pip install awscli"
end

execute "upgrade_awscli" do
  user "root"
  command "pip install --upgrade awscli"
end


# install ec2 monitor scripts
# -------------------------------------

bash "install_aws_scripts_mon" do
	cwd node[:mysite_base][:home]
	code <<-EOF
		wget http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/CloudWatchMonitoringScripts-v1.1.0.zip
		unzip CloudWatchMonitoringScripts-v1.1.0.zip
		rm CloudWatchMonitoringScripts-v1.1.0.zip
	EOF
	not_if { ::File.directory?("#{node[:mysite_base][:home]}/aws-scripts-mon") }
end

