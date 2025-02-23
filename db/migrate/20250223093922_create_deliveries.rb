class CreateDeliveries < ActiveRecord::Migration[8.0]
  def change
    create_table :deliveries do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :courier, null: false, foreign_key: true
      t.references :origin, foreign_key: { to_table: 'addresses' }
      t.datetime :pickup
      t.references :destination, foreign_key: { to_table: 'addresses' }
      t.datetime :delivered
      t.references :tariff, null: false, foreign_key: true
      t.boolean :invoiced
      t.boolean :reimburse

      t.timestamps
    end
  end
end
