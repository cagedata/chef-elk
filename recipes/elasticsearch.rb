#
# Cookbook Name:: elk
# Recipe:: elasticsearch
#
# Copyright (c) 2016 Dave Long, All Rights Reserved.

package 'java-1.8.0-openjdk'

yum_repository 'elasticsearch' do
  description 'Elasticsearch repository for 2.x packages'
  baseurl 'https://packages.elastic.co/elasticsearch/2.x/centos'
  gpgkey 'https://packages.elastic.co/GPG-KEY-elasticsearch'
  action :create
end

package 'elasticsearch'

directory 'elastic_data_dir' do
  path node['elastic']['data_dir']
  recursive true
  owner 'elasticsearch'
  group 'elasticsearch'
end

directory 'elastic_log_dir' do
  path node['elastic']['log_dir']
  recursive true
  owner 'elasticsearch'
  group 'elasticsearch'
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0750'
  notifies :restart, 'service[elasticsearch]', :delayed
end

# firewall_rule 'elasticsearch' do
#   port node['elastic']['http_port']
#   command :allow
# end

service 'elasticsearch' do
  action [:start, :enable]
end

# Block anything else from happening until Elasticsearch is green
# Ignore the hackiness... stupid Java
ruby_block 'wait_for_elasticsearch' do
  block do
    require 'timeout'
    require 'English'
    require 'mixlib/shellout'
    Timeout.timeout(30) do
      loop do
        host = "#{node['ipaddress']}:#{node['elastic']['http_port']}"
        curl = Mixlib::ShellOut.new <<-EOS.chomp
          curl #{host}/_cluster/health?pretty 2>/dev/null \
            | grep status | grep green && echo OK || echo ERROR 2>/dev/null
        EOS
        curl.run_command
        break if curl.exitstatus.zero?
        sleep 1
      end
    end
  end
  action :nothing
  subscribes :run, 'service[elasticsearch]', :immediately
end
