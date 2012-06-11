require 'json'
require 'chatbot_api', "1.0", git: "git://github.com/HungryAcademyTeam4/chatbot_api.git"
require 'erb'

class ConquerGithub 
  attr_reader :repo 

  DEFAULT_TEMPLATE = "[<=% commit['repo'] %>] 
                       <%= commit['message'] %> - 
                       <%= commit['author']['name'] %> 
                       (<%= commit['url'] %>)".freeze 

  def initialize 
    @repos = YAML.load_file(ENV['CONFIG'] || 'config.yml')
    process_payload(payload) if payload 
  end 

  def process_payload 
    payload = JSON.parse(payload)
    return unless payload.keys.include?("repository")
    @repo = payload["repository"]["name"]

    @room = connect(@repo)
    commits = payload["commits"]
    if commits.is_a?(Hash)
      commits = commits.map do |id,c|
        c["id"] = id
        c
      end 
    end 
    commits.sort_by { |c| c["timestamp"] }.each { |c| process_commit(c) }
  end 

  def connect

  end 

  def template
    
  end 

  def process_commit 
  end 
end 