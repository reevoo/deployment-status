class AddVisibleToWorkflowEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :workflow_events, :visible, :boolean, default: false
  end
end
