gem 'hoe', '~> 3.0.7'
require 'hoe'
require 'fileutils'

Hoe.plugin :newgem

$hoe = Hoe.spec 'ovo_report_summarizer' do
  developer 'Kenichi Kamiya', 'kachick1+ruby@gmail.com'
  self.rubyforge_name       = name
  require_ruby_version '>= 1.9.3'
  dependency 'striuct', '~> 0.3.0', :runtime
  dependency 'lettercase', '~> 0.0.2', :runtime
  dependency 'declare', '~> 0.0.4', :development
  dependency 'yard', '>= 0.8.2.1', :development
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each {|t|load t}