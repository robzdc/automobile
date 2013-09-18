class CreateAdverts < ActiveRecord::Migration

  def change
    create_table :adverts do |t|
      t.string :image
      t.string :title
      t.string :url
      t.integer :price
      t.string :location
      t.string :phone
      t.text :comment
      t.string :color
      t.integer :km
      t.string :make
      t.string :model
      t.string :state
      t.integer :year

      t.timestamps
    end
    
    add_index(:adverts, :make, {name: "idx_advert_make"})
    add_index(:adverts, :model, {name: "idx_advert_model"})
    add_index(:adverts, :state, {name: "idx_advert_state"})
    add_index(:adverts, :year, {name: "idx_advert_year"})
    add_index(:adverts, :km, {name: "idx_advert_km"})
    add_index(:adverts, :price, {name: "idx_advert_price"})
  end
end
