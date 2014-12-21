require 'rake'
require 'json'
require 'rspec/core/rake_task'

properties_file = 'properties.json'
properties = JSON.parse(File.read(properties_file))

properties.keys.each do |key|
  desc "Run provision to #{key}"
  namespace :itamae do
    desc "Run itamae to #{key}"
    task key.split('.')[0] do
      ENV['TARGET_HOST'] = key
      command = "bundle exec itamae ssh"
      command << " -h #{key}"
      command << " -u #{properties[key]['ssh_user']}"
      command << " -i #{properties[key]['private_key']}"
      command << " -p #{properties[key]['ssh_port']}"
      command << " -j #{properties_file}"
      properties[key]['roles'].each {|role| command << " recipes/#{role}/#{role}.rb"}
      puts command
      system command
    end
  end

  namespace :serverspec do
    desc "Run serverspec to #{key}"
    RSpec::Core::RakeTask.new(key.split('.')[0].to_sym) do |t|
      ENV['TARGET_HOST'] = key
      t.pattern = 'spec/{' + properties[key]['roles'].join(',') + '}/*_spec.rb'
    end
  end
end
