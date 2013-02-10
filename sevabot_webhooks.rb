require 'sinatra'
require 'httparty'
require 'awesome_print'
require './lib/github_push'

SEVABOT_HOST = ENV['SEVABOT_HOST']
unless SEVABOT_HOST
  raise 'Missing SEVABOT_HOST environment variable'
end

SEVABOT_PORT = ENV['SEVABOT_PORT']
unless SEVABOT_PORT
  raise 'Missing SEVABOT_PORT environment variable'
end

post '/:webhook/:chat_id/:shared_secret' do
  case params[:webhook]
  when 'github-post-commit'
    github_push = GithubPush.new(params[:payload])
    HTTParty.post sevabot_url, :body => {:msg => github_push.messages.join("\n")}
  else
    halt "Invalid webhook: #{params[:webhook]}"
  end
  ""
end

get '/test/:webhook/:chat_id/:shared_secret' do
  case params[:webhook]
  when 'github-post-commit'
    sample_payload = GithubPushHelper.sample_payload
    github_push = GithubPush.new(sample_payload)
    HTTParty.post sevabot_url, :body => {:msg => github_push.messages.join("\n")}
  else
    halt "Invalid webhook: #{params[:webhook]}"
  end
  ""
end

helpers do
  def sevabot_url
    "http://#{SEVABOT_HOST}:#{SEVABOT_PORT}/message/#{params[:chat_id]}/#{params[:shared_secret]}/"
  end
end
