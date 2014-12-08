class Comment < ActiveRecord::Base
	belongs_to :user
	attr_accessible :posting, :private
	
	#validates :user_id, :pressence => true
	#validates :posting, :pressence => true, :length => { maximum: 200 }
	
	default_scope order: "comments.created_at DESC"
	
end
