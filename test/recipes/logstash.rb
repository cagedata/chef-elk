# # encoding: utf-8

# Inspec test for recipe elk::logstash

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe package('logstash') do
  it { should be_installed }
end

describe service('logstash') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(5044) do
  it { should be_listening }
  its('processes') { should include 'java' }
end
