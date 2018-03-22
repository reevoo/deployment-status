class CreateWorkflowEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :workflow_events do |t|
      t.datetime :timestamp
      t.string :issue_key
      t.string :issue_title
      t.text :issue_description
      t.string :issue_labels, array: true
      t.jsonb :payload
    end
  end
end
