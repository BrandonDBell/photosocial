class CreatePcomments < ActiveRecord::Migration
	def change
		create_table :pcomments do |t|
			t.references :user
			t.references :photo
			t.string :posting
			
			t.timestamps
		end
		add_index :pcomments, [:user_id, :photo_id, :created_at]
	end
end
