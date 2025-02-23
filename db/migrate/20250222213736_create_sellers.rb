class CreateSellers < ActiveRecord::Migration[8.0]
  def change
    create_table :sellers do |t|
      t.references :person, null: false, foreign_key: true
      t.jsonb :settings

      t.timestamps
    end
  end
end
