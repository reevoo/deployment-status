require "date"

class WorkflowEvent < ActiveRecord::Base
  scope :for_display, -> { select(column_names - ["payload"]).where(visible: true).order(timestamp: :desc) }

  def self.create_from_payload!(payload)
    description = payload["issue"]["fields"]["customfield_13602"]
    create!(
      timestamp:          Time.at(payload["timestamp"].to_i / 1000).to_datetime,
      issue_key:          payload["issue"]["key"],
      issue_title:        payload["issue"]["fields"]["summary"],
      issue_description:  description,
      issue_labels:       payload["issue"]["fields"]["labels"] || [],
      visible:            description.present? && payload["transition"] && payload["transition"]["to_status"] == "Deployed",
      payload:            payload,
    )
  end
end
