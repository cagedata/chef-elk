#
# Cookbook Name:: .
# Recipe:: logstash
#
# Copyright (c) 2016 Dave Long, All Rights Reserved.

###
# Handlers
###
execute 'daemon_reload' do
  command 'systemctl --system daemon-reload'
  action :nothing
end
###
# /Handlers
###

package 'java-1.8.0-openjdk'

yum_repository 'logstash' do
  description 'Logstash repository for 2.4.x packages'
  baseurl 'https://packages.elastic.co/logstash/2.4/centos'
  gpgkey 'https://packages.elastic.co/GPG-KEY-elasticsearch'
  action :create
end

package 'logstash'

directory 'logstash_log_dir' do
  path node['logstash']['log_dir']
  recursive true
  owner 'logstash'
  group 'logstash'
end

template '/etc/logstash/conf.d/02-beats-input.conf' do
  source 'logstash/beats_input.conf.erb'
  user 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[logstash]', :delayed
end

template '/etc/logstash/conf.d/30-elasticsearch-output.conf' do
  source 'logstash/elasticsearch_output.conf.erb'
  user 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[logstash]', :delayed
end

template '/usr/lib/systemd/system/logstash.service' do
  source 'logstash.service.erb'
  user 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[daemon_reload]', :immediate
end

service 'logstash' do
  action [:start, :enable]
end
