class AddUserToRegistres < ActiveRecord::Migration
  def change
    add_column :registres, :user_id, :integer
  end
end
