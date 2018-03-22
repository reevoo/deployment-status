require "date"

class WorkflowEvent < ActiveRecord::Base
  def self.create_from_payload!(payload)
    create!(
      timestamp:          Time.at(payload["timestamp"].to_i / 1000).to_datetime,
      issue_key:          payload["issue"]["key"],
      issue_title:        payload["issue"]["fields"]["summary"],
      issue_description:  payload["issue"]["fields"]["description"],
      issue_labels:       payload["issue"]["fields"]["labels"],
      payload:            payload,
    )
  end

  def self.select_without_payload
    select(column_names - ["payload"])
  end
end
