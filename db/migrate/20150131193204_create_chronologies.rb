class CreateChronologies < ActiveRecord::Migration
  def change
    create_table :chronologies do |t|
      t.string :title
      t.references :event

      t.timestamps
    end
    add_index :chronologies, :event_id
  end
end
