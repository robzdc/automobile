class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.integer :active

      t.timestamps
    end
  end
end
