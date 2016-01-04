class AddLinkedHistoryIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :linked_history_id, :integer
  end
end
