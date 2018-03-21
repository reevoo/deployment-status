class CreateWorkflowEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :workflow_events do |t|
      t.datetime :timestamp
      t.datetime :issue_key
      t.datetime :issue_title
      t.datetime :issue_description
      t.string :issue_labels, array: true
      t.jsonb :payload
    end
  end
end
