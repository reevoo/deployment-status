require "sinatra/base"
require "active_record"
require "json"
require_relative "./models/workflow_event"

ActiveRecord::Base.establish_connection(ENV.fetch("DATABASE_URL"))

class App < Sinatra::Application
  set :views, "views"

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
    @grouped_events = WorkflowEvent.for_display.group_by do |event|
      event.timestamp.strftime("%A %m/%d/%Y")
    end
    slim :index
  end

  get "/healthcheck" do
    JSON.dump(status: "ok")
  end

  post "/workflow-event-hook" do
    request.body.rewind
    json_payload = request.body.read
    logger.info(json_payload)
    payload = JSON.parse(json_payload)
    WorkflowEvent.create_from_payload!(payload)
  end
end
