class AddOwnerToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :owner, :integer
  end
end
