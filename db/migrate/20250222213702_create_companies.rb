class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.references :person, null: false, foreign_key: true
      t.integer :kind
      t.jsonb :settings

      t.timestamps
    end
  end
end
