module SemaphoreBuildHelper
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    # Example:
    # "(sun) PASSED envision/feature/style #1 (10 mins) https://semaphoreapp.com/projects/1234/branches/5678/builds/1"
    def summary_message
      "#{emoticon} #{result.upcase} #{project_name}/#{branch_name} ##{build_number} #{duration_summary}#{build_url}"
    end

    def result
      payload['result']
    end

    def emoticon
      case result
      when 'passed'
        '(sun)'
      when 'failed'
        '(rain)'
      end
    end

    def project_name
      payload['project_name']
    end

    def branch_name
      payload['branch_name']
    end

    def build_number
      payload['build_number']
    end

    def build_url
      payload['build_url']
    end

    def started_at
      Time.parse(payload['started_at'])
    end

    def finished_at
      if payload['finished_at']
        Time.parse(payload['finished_at'])
      end
    end

    def duration_in_minutes
      if started_at && finished_at
        ((finished_at - started_at) / 60).round
      end
    end

    def duration_summary
      if duration_in_minutes
        "(#{duration_in_minutes} mins) "
      end
    end
  end
end
