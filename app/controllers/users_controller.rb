class UsersController < ApplicationController
 
 before_filter :signed_in_admin, only: [:new, :edit, :update, :toggle_approve ]


 


  def index
    @histories = History.all
  end



	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
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

def signed_in_admin
 redirect_to signin_path, notice: "Please sign in as admin." unless current_user.admin
end



end
