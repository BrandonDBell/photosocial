module ApplicationHelper
	
	def title
		original = "SnapShot"
		if @title
			"#{original} | #{@title}"
		else
			original
		end
	end
end
