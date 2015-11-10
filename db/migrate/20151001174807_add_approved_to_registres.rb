class AddApprovedToRegistres < ActiveRecord::Migration
  def change
    add_column :registres, :approved, :boolean, default: false
  end
end
