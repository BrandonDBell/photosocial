class CreateComments < ActiveRecord::Migration
	def change
		create_table :comments do |t|
			t.references :user
			t.integer :poster
			t.string :posting
			t.boolean :private, :default => false
			
			t.timestamps
		end
		add_index :comments, [:user_id, :created_at]
	end
end
