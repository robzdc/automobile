class CreateCompareMakes < ActiveRecord::Migration
  def change
    create_table :compare_makes do |t|
      t.integer :make_id
      t.integer :website_id
      t.string :value

      t.timestamps
    end
  end
end
