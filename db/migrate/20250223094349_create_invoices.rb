class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.date :issued
      t.string :code
      t.integer :charge
      t.string :remarks

      t.timestamps
    end
  end
end
