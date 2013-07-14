class CreateCompareModels < ActiveRecord::Migration
  def change
    create_table :compare_models do |t|
      t.integer :model_id
      t.integer :website_id
      t.string :value

      t.timestamps
    end
  end
end
