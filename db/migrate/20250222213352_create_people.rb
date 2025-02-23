class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :nick
      t.string :name
      t.string :surname1
      t.string :surname2
      t.date :birthday
      t.string :cif
      t.string :phone
      t.string :email
      t.string :address
      t.jsonb :settings

      t.timestamps
    end
  end
end
