require './lib/semaphore_build_helper'

class SemaphoreBuild
  include SemaphoreBuildHelper

  attr_reader :payload

  def initialize(params, raw_body)
    @payload = JSON.parse(raw_body)
  end

  def messages
    messages = []
    unless result == 'pending'
      messages << summary_message
    end
    messages
  end
end
