class Pcomment < ActiveRecord::Base
	belongs_to :photo
	belongs_to :user
	attr_accessible :posting
	
	#validates :user_id, :pressence => true
	#validates :posting, :pressence => true, :length => { maximum: 200 }
	
	default_scope order: "pcomments.created_at DESC"
	
end
