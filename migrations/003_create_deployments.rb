class CreateDeployments < ActiveRecord::Migration[5.0]
  def change
    create_table :deployments do |t|
      t.datetime :timestamp
      t.string :issue_key
      t.string :issue_title
      t.text :issue_description
      t.string :issue_labels, array: true
      t.integer :workflow_event_id
    end

    remove_column :workflow_events, :visible
    remove_column :workflow_events, :issue_key
    remove_column :workflow_events, :issue_description
    remove_column :workflow_events, :issue_labels
  end
end
