class CreateCompareStates < ActiveRecord::Migration
  def change
    create_table :compare_states do |t|
      t.integer :state_id
      t.integer :website_id
      t.string :value

      t.timestamps
    end
  end
end
