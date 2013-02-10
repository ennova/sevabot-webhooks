require './lib/github_push_helper'

class GithubPush
  include GithubPushHelper

  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  # https://github.com/github/github-services/blob/master/lib/services/campfire.rb (receive_push method)
  def messages
    messages = []
    messages << "#{summary_message}: #{summary_url}"
    messages += commit_messages.first(8)

    if messages.first =~ /pushed 1 new commit/
      messages.shift # drop summary message
      messages.first << " ( #{distinct_commits.first['url']} )"
    end

    messages
  end
end
