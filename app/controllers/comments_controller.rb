class CommentsController < ApplicationController
  before_filter :load_user
  before_filter :authenticate_user!
  
	def new
		@title = "New Comment"
		@comment = @user.comments.build
	end
  
	def create
		@comment = @user.comments.build(params[:comment])
		@comment.poster = current_user.id
		if @comment.save
			redirect_to user_url(@user), notice: "Comment posted"
		else
			render action: 'new'
		end
	end
  
	def edit
		@title = "Edit Comment"
		@comment = @user.comments.find(params[:id])
	end
  
	def update
		@title = "Update Photo"
		@comment = @user.comments.find(params[:id])
		if @comment.update_attributes(params[:comment])
			redirect_to user_comment_url(@user, @comment)
		else
			render action: 'edit'
		end
	end
  
	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		respond_to do |format|
			redirect_to user_url(@comment.user_id)
		end
  end
  
  private

	def load_user
		@user = User.find(params[:user_id])
	end
	
end
