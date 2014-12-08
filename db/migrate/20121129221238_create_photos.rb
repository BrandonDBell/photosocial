class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :user
      t.string :title
      t.integer :rating
      t.boolean :private, :default => false
      t.text :description
      t.integer :view_count
      t.integer :date_uploaded
      t.date :last_view
      t.integer :num_comments

      t.timestamps
    end
    add_index :photos, :user_id
  end
end
