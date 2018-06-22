require "sinatra/base"
require "active_record"
require "json"
require_relative "./models/workflow_event"
require_relative "./models/deployment"

ActiveRecord::Base.establish_connection(ENV.fetch("DATABASE_URL"))

class App < Sinatra::Application
  set :views, "views"

  get "/" do
    @events = Deployment.order(timestamp: :desc).page(params[:page]).per(10)
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
    workflow_event = WorkflowEvent.create_from_payload!(payload)
    Deployment.process_workflow_event!(workflow_event)
  end
end
