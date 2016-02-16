class ChangeContentTypeInGedcoms < ActiveRecord::Migration
  def up
  	change_column :gedcoms, :content, :text
  end
end
