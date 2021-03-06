require 'sinatra'
require 'httparty'
require 'awesome_print'
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
      body = request.body.read
      webhook = webhook_adapter.new(params, body)
      message = webhook.messages.join("\n")
      unless message.empty?
        HTTParty.post sevabot_url, :body => {:msg => message}
      end
    rescue Exception => e
      error_message = "Error: #{request.host}: #{params[:webhook]}\n"
      error_message += e.message + "\n"
      error_message += e.backtrace.first(5).join("\n")
      error_message += "\n\n#{params}"
      error_message += "\n\n#{body}"
      HTTParty.post sevabot_url, :body => {:msg => error_message}
    end
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
