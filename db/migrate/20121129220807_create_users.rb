class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name
      t.date :date_created
      t.date :last_login
      t.boolean :private, :default => false

      t.timestamps
    end
  end
end
