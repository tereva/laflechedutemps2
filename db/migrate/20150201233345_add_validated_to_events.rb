class AddValidatedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :validated, :boolean
  end
end
