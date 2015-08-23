class AddApprovedAndUserIdToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :user_id, :integer
    add_column :histories, :approved, :boolean, default: false
    add_index :histories, [:user_id, :created_at]
  end
end
