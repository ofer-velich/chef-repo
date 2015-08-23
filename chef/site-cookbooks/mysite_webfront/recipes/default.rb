#
# Cookbook Name:: mysite_webfront
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# install mysite_webfront packages
# -------------------------------------
node[:mysite_webfront][:packages].each do |p|
  package p
end


# install s3 packages
# -------------------------------------
node[:mysite_webfront][:s3][:packages].each do |p|
    execute "s3 get dpkg" do
      cwd "/home/ubuntu"
      command "s3cmd get --force s3://deb.mysite.fm/ubuntu/#{node[:mysite_base][:machine][:version]}/#{p} #{node[:mysite_base][:home]}/#{p} > /dev/null"
    end

    dpkg_package p do
      source "#{node[:mysite_base][:home]}/#{p}"
    end

    execute "rm #{node[:mysite_base][:home]}/#{p}"
end

# setup scripts sites folder
# -------------------------------------
directory "#{node[:mysite_base][:scripts]}/sites" do
	owner node[:mysite_base][:user]
	group node[:mysite_base][:group]
	mode '0755'
end

# setup sites folder
# -------------------------------------
directory "#{node[:mysite_base][:sites]}" do
	owner node[:mysite_base][:user]
	group node[:mysite_base][:group]
	mode '0755'
end


# install corn jobs
# -------------------------------------
cron "ec2_reports" do
  action :create
  user node[:mysite_base][:user]
  minute '*/5'
  home "#{node[:mysite_base][:home]}"
  command ". #{node[:mysite_base][:home]}.bash_profile; #{node[:mysite_base][:home]}/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --swap-util --swap-used --disk-path=/ --disk-space-used --disk-space-avail --from-cron --aws-access-key-id=${AWS_ACCESS_KEY_ID} --aws-secret-key=${AWS_SECRET_ACCESS_KEY} --auto-scaling=only"
end

# if we have node install link it to the user 
# -------------------------------------
execute "update_npm_owner" do
	user "root"
	command "chown -R $(whoami) #{node[:mysite_base][:home]}/.npm"
	only_if { ::File.exists? "#{node[:mysite_base][:home]}/.npm" }

end

