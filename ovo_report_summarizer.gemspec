Gem::Specification.new do |gem|
  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.summary       = %q{An utility for the OVO(OpenViewOperations).
"Report file" to a csv file.}
  gem.description   = gem.summary.dup
  gem.homepage      = 'https://github.com/kachick/ovo_report_summarizer'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'ovo_report_summarizer'
  gem.require_paths = ['lib']
  gem.version       = '0.0.1.1'

  gem.required_ruby_version = '>= 1.9.2'

  gem.add_runtime_dependency 'striuct', '~> 0.4.0'
  gem.add_runtime_dependency 'lettercase', '~> 0.0.3'

  gem.add_development_dependency 'declare', '~> 0.0.5'
  gem.add_development_dependency 'yard', '~> 0.8'
end

