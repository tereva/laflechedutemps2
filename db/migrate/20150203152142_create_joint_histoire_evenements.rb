class CreateJointHistoireEvenements < ActiveRecord::Migration
  def change
    create_table :joint_histoire_evenements do |t|
      t.references :event
      t.references :history

      t.timestamps
    end
    add_index :joint_histoire_evenements, :event_id
    add_index :joint_histoire_evenements, :history_id
  end
end
