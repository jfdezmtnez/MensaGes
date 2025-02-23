class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :number
      t.string :floor
      t.string :city
      t.string :province
      t.string :state
      t.string :country
      t.string :postcode

      t.timestamps
    end
  end
end
