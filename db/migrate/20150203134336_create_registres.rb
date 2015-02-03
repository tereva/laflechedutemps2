class CreateRegistres < ActiveRecord::Migration
  def change
    create_table :registres do |t|
      t.references :history
      t.references :event

      t.timestamps
    end
    add_index :registres, :history_id
    add_index :registres, :event_id
  end
end
