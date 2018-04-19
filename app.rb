require "sinatra/base"
require "active_record"
require "json"
require_relative "./models/workflow_event"

ActiveRecord::Base.establish_connection(ENV.fetch("DATABASE_URL"))

class App < Sinatra::Application
  set :views, "views"

  get "/" do
    @events = WorkflowEvent.for_display.page(params[:page]).per(10)
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
