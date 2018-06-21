class Deployment < ActiveRecord::Base
  DESCRIPTION_FIELD_ID = "customfield_13602"

  def self.process_workflow_event!(event)
    changelog_items = event.payload.dig("changelog", "items")
    description_item_change = changelog_items && changelog_items.find { |i| i["fieldId"] == DESCRIPTION_FIELD_ID }
    return unless description_item_change && description_item_change["toString"].present?

    issue_key = event.payload["issue"]["key"]
    attributes = {
      workflow_event_id:  event.id,
      issue_key:          issue_key,
      issue_title:        event.payload["issue"]["fields"]["summary"],
      issue_description:  description_item_change["toString"],
      issue_labels:       event.payload["issue"]["fields"]["labels"] || [],
    }

    record = find_by(issue_key: issue_key)
    if record
      record.update!(attributes)
    else
      create!(attributes.merge(timestamp: event.timestamp))
    end
  end
end
