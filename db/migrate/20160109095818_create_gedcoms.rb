class CreateGedcoms < ActiveRecord::Migration
  def change
    create_table :gedcoms do |t|
      t.string :name
      t.string :content
      t.boolean :public, default: false
      t.integer :user_id
      t.timestamps
    
    end
      add_index :gedcoms, [:user_id, :created_at]
  end
end
