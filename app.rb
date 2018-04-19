require "sinatra/base"
require "active_record"
require "json"
require_relative "./models/workflow_event"

ActiveRecord::Base.establish_connection(ENV.fetch("DATABASE_URL"))

class App < Sinatra::Application
  set :views, "views"

  get "/" do
    @grouped_events = WorkflowEvent.for_display.group_by do |event|
      event.timestamp.strftime("%A %d/%m/%Y")
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
