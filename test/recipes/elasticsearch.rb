# # encoding: utf-8

# Inspec test for recipe elk::elasticsearch

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe group('elasticsearch') do
  it { should exist }
end

describe service('elasticsearch') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(9200) do
  it { should be_listening }
  its('processes') { should include 'java' }
end

describe file('/etc/elasticsearch/elasticsearch.yml') do
  its('content') { should match(%r{path\.data:\s?\/srv\/elasticsearch\/data}) }
  its('content') { should match(%r{path\.logs:\s?\/srv\/elasticsearch\/logs}) }
  its('content') { should match(/cluster\.name:\s?kitchen-sink/) }
end

# I really wish this would work.
# describe yaml('/etc/elasticsearch/elasticsearch.yml') do
#   its('path.data') { should eq '/srv/elasticsearch/data' }
#   its('path.logs') { should eq '/srv/elasticsearch/logs' }
# end
