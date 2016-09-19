default['firewall']['allow_ssh'] = true
default['firewall']['firewalld']['permanent'] = true

default['elastic']['host'] = '127.0.0.1'
default['elastic']['http_port'] = 9200
default['elastic']['data_dir'] = '/srv/elasticsearch/data'
default['elastic']['log_dir'] = '/srv/elasticsearch/logs'
default['elastic']['cluster'] = 'elk-production'
default['elastic']['minimum_mast_nodes'] = 1 # Set to (number of nodes / 2 + 1)
