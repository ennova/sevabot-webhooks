require 'sinatra'
require 'httparty'
require 'awesome_print'
require 'json'
require './lib/github_push'
require './lib/semaphore_build'

SEVABOT_HOST = ENV['SEVABOT_HOST']
unless SEVABOT_HOST
  raise 'Missing SEVABOT_HOST environment variable'
end

SEVABOT_PORT = ENV['SEVABOT_PORT']
unless SEVABOT_PORT
  raise 'Missing SEVABOT_PORT environment variable'
end

post '/:webhook/:chat_id/:shared_secret' do
  if webhook_adapter
    begin
      payload = JSON.parse(params[:payload])
      webhook = webhook_adapter.new(payload)
      message = webhook.messages.join("\n")
      HTTParty.post sevabot_url, :body => {:msg => message}
    rescue Exception => e
      error_message = "Error: #{request.host}: #{params[:webhook]}\n"
      error_message += e.message + "\n"
      error_message += e.backtrace.first(5).join("\n")
      error_message += "\n\n#{params[:payload]}"
      HTTParty.post sevabot_url, :body => {:msg => error_message}
    end
  else
    halt "Invalid webhook: #{params[:webhook]}"
  end
  ""
end

get '/test/:webhook/:chat_id/:shared_secret' do
  if webhook_adapter
    sample_payload = webhook_adapter.sample_payload
    webhook = webhook_adapter.new(sample_payload)
    HTTParty.post sevabot_url, :body => {:msg => webhook.messages.join("\n")}
  else
    halt "Invalid webhook: #{params[:webhook]}"
  end
  ""
end

helpers do
  def sevabot_url
    "http://#{SEVABOT_HOST}:#{SEVABOT_PORT}/message/#{params[:chat_id]}/#{params[:shared_secret]}/"
  end

  def webhook_adapter
    @webhook_adapter ||= case params[:webhook]
    when 'github-post-commit'
      GithubPush
    when 'semaphore-build'
      SemaphoreBuild
    end
  end
end
