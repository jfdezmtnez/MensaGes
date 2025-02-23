class CreatePackages < ActiveRecord::Migration[8.0]
  def change
    create_table :packages do |t|
      t.string :description
      t.float :value
      t.float :weight
      t.float :length
      t.float :width
      t.float :height

      t.timestamps
    end
  end
end
