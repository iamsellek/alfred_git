# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alfred_git/version'

Gem::Specification.new do |spec|
  spec.name           = 'alfred_git'
  spec.version        = AlfredGit::VERSION
  spec.authors        = ['Chris Sellek']
  spec.email          = ['iamsellek@gmail.com']

  spec.summary        = 'Helps you handle multiple git repos more quickly and easily.'
  spec.description    = 'See GitHub page for longer description.'
  spec.homepage       = 'https://github.com/iamsellek/alfred_git'
  spec.license        = 'MIT'

  spec.files          = `git ls-files`.split($/)
  spec.executables    = ['alfred_git']
  spec.test_files     = []
  spec.require_paths  = ['lib']

  spec.add_dependency 'rainbow'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
end