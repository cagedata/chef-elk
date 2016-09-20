#
# Cookbook Name:: elk
# Spec:: default
#
# Copyright (c) 2016 Cage Data, All Rights Reserved.

require 'spec_helper'

describe 'elk::elasticsearch' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs elasticsearch package' do
      expect(chef_run).to install_package 'elasticsearch'
    end

    it 'adds configuration file' do
      expect(chef_run).to create_template '/etc/elasticsearch/elasticsearch.yml'
    end

    it 'starts elasticsearch' do
      expect(chef_run).to start_service 'elasticsearch'
    end

    it 'enables elasticsearch at startup' do
      expect(chef_run).to enable_service 'elasticsearch'
    end
  end
end
