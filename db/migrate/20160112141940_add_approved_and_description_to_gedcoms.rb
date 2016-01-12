class AddApprovedAndDescriptionToGedcoms < ActiveRecord::Migration
  def change
    add_column :gedcoms, :approved, :boolean, default: false
    add_column :gedcoms, :description, :string
  end
end
