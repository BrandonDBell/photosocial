class PhotosController < ApplicationController
	before_filter :authenticate_user!
	
  	def index
  		if params[:tag]
  			@photos = Photo.tagged_with(params[:tag])
  		else
  			@photos = Photo.all
  		end
  	end

  	def vote
  		value = params[:type] == "up" ? 1 : -1
  		@photo = Photo.find(params[:id])
  		@photo.add_or_update_evaluation(:votes, value, current_user)
  		redirect_to :back, notice: "Thank you for voting"
	end

	def show
		@title = "View Image"
		@photo = Photo.find(params[:id])
		@user = User.find(params[:user_id])
		@photos = Photo.find_with_reputation(:votes, :all, order: "votes desc")
	end

	def new
		@title = "Upload a Picture"
		@user = User.find(params[:user_id])
		@photo = @user.photos.build
	end

	def edit
		@title = "Edit Photo"
		@user = User.find(params[:user_id])
		@photo = @user.photos.find(params[:id])
	end

	def create 
		@user = User.find(params[:user_id])
		@photo = @user.photos.build(params[:photo])
		if @photo.save
			redirect_to user_url(@user), notice: 'Photo was successfully created.'
		else
			render action: "new"
		end
	end

	def update
		@title = "Edit Photo"
		@user = User.find(params[:user_id])
		@photo = @user.photos.find(params[:id])
		if @photo.update_attributes(params[:photo])
			redirect_to user_photo_url(@user, @photo), notice: 'Photo was successfully updated.'
		else
			render action: "edit"
		end
	end

	def destroy
		@user = User.find(params[:user_id])
		@photo = @user.photos.find(params[:id])
		@photo.destroy
		respond_to do |format|
			redirect_to user_url(@user), notice: 'Deleted photo'
		end
	end
 end
