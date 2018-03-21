require "sinatra/base"
require "active_record"
require "json"
require_relative "./models/workflow_event"

ActiveRecord::Base.establish_connection(ENV.fetch("DATABASE_URL"))

class App < Sinatra::Application

  # get "/" do
  #   jira_client = JIRA::Client.new(
  #     username:     ENV.fetch("JIRA_USERNAME"),
  #     password:     ENV.fetch("JIRA_API_KEY"),
  #     site:         ENV.fetch("JIRA_SITE"),
  #     auth_type:    :basic,
  #     context_path: ''
  #   )
  #   project = jira_client.Project.find('PROD')

  #   project.issues.map do |issue|
  #     "#{issue.id} - #{issue.summary}"
  #   end.join("\n")
  # end

  get "/" do
    @events = WorkflowEvent.select_without_payload.order(timestamp: :desc).all
    slim :index
  end

  post "/workflow-event-hook" do
    request.body.rewind
    payload = JSON.parse(request.body.read)
    WorkflowEvent.create_from_payload!(payload)
  end
end
