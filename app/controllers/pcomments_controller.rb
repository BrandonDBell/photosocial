class PcommentsController < ApplicationController
  before_filter :load
  before_filter :authenticate_user!
  
	def new
		@title = "New Pcomment"
		#@pcomment = @user.@photo.pcomments.build
	end
  
	def create
		#@pcomment = @user.pcomments.build(params[:pcomment])
		if @pcomment.save
			redirect_to photo_url(@photo), notice: "Pcomment posted"
		else
			render action: 'new'
		end
	end
  
	def edit
		@title = "Edit Pcomment"
		@pcomment = @user.pcomments.find(params[:id])
	end
  
	def update
		@title = "Update Photo"
		@pcomment = @photo.pcomments.find(params[:id])
		if @pcomment.update_attributes(params[:pcomment])
			redirect_to user_photo_pcomment_url(@user, @photo, @pcomment)
		else
			render action: 'edit'
		end
	end
  
	def destroy
		@pcomment = Pcomment.find(params[:id])
		@pcomment.destroy
		respond_to do |format|
			redirect_to user_photo_url(@pcomment.photo_id)
		end
  end
  
  private

	def load
		@photo = Photo.find(params[:photo_id])
		@user = User.find(params[:user_id])
	end
	
end
