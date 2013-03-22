require './lib/semaphore_build_helper'

class SemaphoreBuild
  include SemaphoreBuildHelper

  attr_reader :payload

  def initialize(params)
    @payload = JSON.parse(params.keys.first)
  end

  def messages
    messages = []
    unless result == 'pending'
      messages << summary_message
    end
    messages
  end
end
