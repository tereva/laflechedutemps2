class UsersController < ApplicationController
 
 before_filter :signed_in_user
 before_filter :admin_user, only: [:index, :new, :toggle_approve ]
 before_filter :correct_user, only: [:edit, :update]

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

 	def toggle_approve
    @histo2=History.find(params[:id])
    @histo2.toggle!(:approved)
    
    respond_to do |format|
      format.js
    end

    #render :nothing => true
  end


private

def admin_user
 redirect_to signin_path, notice: "Please sign in as admin." unless (signed_in? && current_user.admin?)
end

  def correct_user
   @user = User.find(params[:id])
   redirect_to root_path, notice: "Vous ne pouvez modifier que votre compte" unless (current_user?(@user) || current_user.admin?)
  end


end
