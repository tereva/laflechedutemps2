class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start
      t.datetime :end
      t.boolean :durationEvent
      t.string :place
      t.text :description

      t.timestamps
    end
  end
end
