class UsersController < ApplicationController
 
 before_filter :signed_user
 before_filter :signed_admin, only: [:index, :new, :toggle_approve ]
 before_filter :correct_user, only: [:edit, :update, :show]

  def index
    @users= User.all
  end

  def show
	@user = User.find(params[:id])
  end

	def new
		@user = User.new
	end


  def edit
  end

  def update
   if @user.update_attributes(params[:user])
     flash[:success] = "Modification OK"
     redirect_to @user
   else
    render 'edit'
   end
  end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "Nouveau contributeur cree!"
			redirect_to user_path @user.id
		else
			render 'new'
		end
	end



private



  def correct_user
   @user = User.find(params[:id])
   redirect_to root_path, notice: "Vous ne pouvez modifier que votre compte" unless (current_user?(@user) || current_user.admin?)
  end


end
