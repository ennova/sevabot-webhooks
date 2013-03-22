module SemaphoreBuildHelper
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end

  module InstanceMethods
    # Example:
    # "(sun) PASSED envision/feature/style #1 (10 mins) https://semaphoreapp.com/projects/1234/branches/5678/builds/1"
    def summary_message
      "#{emoticon} #{result.upcase} #{project_name}/#{branch_name} ##{build_number} (#{duration_in_minutes} mins) #{build_url}"
    end

    def result
      payload['result']
    end

    def emoticon
      case result
      when 'passed'
        '(sun)'
      when 'failing'
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
      Time.parse(payload['finished_at'])
    end

    def duration_in_minutes
      ((finished_at - started_at) / 60).round
    end
  end

  module ClassMethods
    def sample_payload
      key = <<-JSON
      {
        "branch_history_url": "http://semaphoreapp.com/api/v1/projects/649e584dc507ca4b73e1374d3125ef0b567a949c/89?auth_token=Yds3w6o26FLfJTnVK2y9",
        "branch_name": "gem_updates",
        "branch_status_url": "http://semaphoreapp.com/api/v1/projects/649e584dc507ca4b73e1374d3125ef0b567a949c/89/status?auth_token=Yds3w6o26FLfJTnVK2y9",
        "branch_url": "https://semaphoreapp.com/projects/44/branches/50",
        "build_number": 15,
        "build_url": "https://semaphoreapp.com/projects/44/branches/50/builds/15",
        "commit": {
          "author_email": "vladimir@renderedtext.com",
          "author_name": "Vladimir Saric",
          "id": "dc395381e650f3bac18457909880829fc20e34ba",
          "message": "Update 'shoulda' gem.",
          "timestamp": "2012-07-04T18:14:08Z",
          "url": "https://github.com/renderedtext/base-app/commit/dc395381e650f3bac18457909880829fc20e34ba"
        },
        "finished_at": "2012-07-09T15:30:16Z",
        "project_name": "base-app",
        "result": "passed",
        "started_at": "2012-07-09T15:23:53Z"
      }
      JSON
      {key => nil}
    end
  end
end
