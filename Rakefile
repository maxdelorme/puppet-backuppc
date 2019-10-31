require 'puppet_litmus/rake_tasks' if Bundler.rubygems.find_name('puppet_litmus').any?
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks' if Bundler.rubygems.find_name('puppet-blacksmith').any?
require 'puppet-strings/tasks' if Bundler.rubygems.find_name('puppet-strings').any?

PuppetLint.configuration.send('disable_relative')

FastGettext.default_text_domain = 'default-text-domain'
