class AddApprovedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :approved, :boolean, default: false
    add_index :events, [:user_id, :created_at]
  end
end
