root = File.absolute_path(File.dirname(__FILE__))

cookbook_path   			["#{root}/cookbooks", "#{root}/site-cookbooks"]
role_path 					"#{root}/roles"
node_path					"#{root}/nodes"
environment_path 			"#{root}/environments"
encrypted_data_bag_secret 	"#{root}/.chef/encrypted_data_bag_secret"