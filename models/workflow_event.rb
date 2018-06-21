require "date"

class WorkflowEvent < ActiveRecord::Base
  def self.create_from_payload!(payload)
    create!(
      timestamp:  Time.at(payload["timestamp"].to_i / 1000).to_datetime,
      payload:    payload,
    )
  end
end
