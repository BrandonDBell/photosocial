class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :authenticate_user!
  
	def show
		@title = "Profile"
		@user = User.find(params[:id])	
	end

	def index
		@title ="All Users"
		@users = User.all
		@users = User.search(params[:search])
	end
	
	def new
		@title = "New User"
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		@title ="Edit User"
		@user = User.find(params[:id])
	end

	def update
		@title = "User Settings"
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to @user, notice: 'User was successfully updated.' 
		else
			render action: "edit"
		end
	end

	def following
    	@title = "Following"
    	@user = User.find(params[:id])
    	@users = @user.following.paginate(page: params[:page])
    	render 'show_follow'
  	end

  	def followers
    	@title = "Followers"
    	@user = User.find(params[:id])
    	@users = @user.followers.paginate(page: params[:page])
    	render 'show_follow'
  	end

  private

	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_url, notice: "Please sign in."
		end
	end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
