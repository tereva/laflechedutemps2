class AddStatusToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :status, :boolean, default: false
  end
end
