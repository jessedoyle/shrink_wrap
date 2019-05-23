# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shrink/wrap/version'

Gem::Specification.new do |spec|
  spec.name = 'shrink_wrap'
  spec.version = Shrink::Wrap::VERSION
  spec.authors = ['Jesse Doyle']
  spec.email = ['jdoyle@ualberta.ca']
  spec.summary = 'Transform complex JSON data into custom Ruby objects'
  spec.description = 'Shrink::Wrap is a dead-simple framework to manipulate' \
                     ' and map JSON data to Ruby object instances.'
  spec.homepage = 'https://github.com/jessedoyle/shrink_wrap'
  spec.license = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
