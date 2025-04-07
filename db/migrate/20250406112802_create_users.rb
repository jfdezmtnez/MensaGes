class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, :email_address, unique: true

    admin = User.new(email_address: "admin@mensages.org")
    admin.password = "langosta"
    admin.save
  end
end
