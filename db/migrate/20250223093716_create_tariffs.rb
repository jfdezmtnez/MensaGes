class CreateTariffs < ActiveRecord::Migration[8.0]
  def change
    create_table :tariffs do |t|
      t.string :description
      t.float :weight
      t.float :distance
      t.time :duration
      t.float :price

      t.timestamps
    end
  end
end
