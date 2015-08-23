name "webfront"
description "The mysite webfront role"

all = [
    "recipe[mysite_base]",
    "recipe[mysite_ec2_tools]",
    "recipe[mysite_webfront]",
    "recipe[mysite_php]",
    "recipe[mysite_apache2]"
]

run_list(all)

env_run_lists(
    "_default" => all,
    "production" => all + ['recipe[mysite_newrelic]'],
    "sandbox" => all,
    "dev" => all
)