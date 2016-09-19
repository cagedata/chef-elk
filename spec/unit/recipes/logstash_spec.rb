#
# Cookbook Name:: .
# Spec:: default
#
# Copyright (c) 2016 Dave Long, All Rights Reserved.

require 'spec_helper'

describe 'elk::logstash' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs logstash' do
      expect(chef_run).to install_package 'logstash'
    end

    it 'creates the logstash service' do
      expect(chef_run)
        .to create_template '/usr/lib/systemd/system/logstash.service'
    end

    it 'creates the logstash configs' do
      expect(chef_run)
        .to create_template '/etc/logstash/conf.d/02-beats-input.conf'
      expect(chef_run)
        .to create_template '/etc/logstash/conf.d/30-elasticsearch-output.conf'
    end
  end
end
