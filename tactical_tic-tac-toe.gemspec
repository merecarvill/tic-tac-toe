# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name              = "tactical_tic_tac_toe"
  s.version           = "0.2.0"
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Command line tic tac toe."
  s.description       = "Command line tic tac toe! Run with command 'ttt'"
  s.authors           = [ "Batman" ]
  s.files             = %w( )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("spec/**/*")
  s.executables       = %w( ttt )
  s.require_paths     = %w( lib )
  s.license           = "MIT"
  s.email             = "no@no.no"
  s.homepage          = "http://rubygems.org/gems/tactical_tic_tac_toe"
end