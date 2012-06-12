require File.join(File.dirname(__FILE__), '..', 'lib', 'github-campfire')
require 'sinatra'

post '/' do
  ConquerGithub.new(params[:payload])
  "New Github Event!"
end