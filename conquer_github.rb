require 'sinatra'
require 'rubygems'
require 'bundler/setup'
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

  def process_payload(payload)
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

  def template
    @template ||= template_for(settings['template'])
  end 

  def template_for 
    case raw 
    when String 
      template_for(:speak => raw )
    when Array 
      raw.map { |1| template_for(1) }.flatten
    when Hash
      method, content = Array(raw).first 
      {method => content.is_a?(String) ? ERB.new(content) : content }
    when nil 
      template(DEFAULT_TEMPLATE)
    else 
      raise ArgumentError, "Invalid Template #{raw.inspect}"
    end
  end 

  def connect
    options = {} 
    options[:ssl] = settings['ssl'] || false 
    options[:proxy] = settings['proxy'] || ENV[options[:ssl] ? 'https_proxy' : 'http_proxy']
    
    #Incomplete method for posting to Chatbot via API
    github = Message.create()
  end 

  def process_commit 
    @repo = commit["repo"]
    proc = Proc.new do 
      commit
    end 
    template.each do |action| 
      method, content = Array(action).first 
      @room.send(method, content.result(proc), :join => false)
    end 
  end 
end 