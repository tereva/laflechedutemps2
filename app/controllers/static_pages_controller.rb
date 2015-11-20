class StaticPagesController < ApplicationController
 


  def home

  	@histories_block_five = History.where(approved: true).limit(5)
    @events_block_five = Event.where(approved: true).limit(5)
  	if signed_admin?
  		@histories_block_admin = History.all
      @registres_block_admin = Registre.all
      @events_block_admin = Event.all
  	end
  	if signed_in?
  		@histories_block_contrib = current_user.histories
  	end

  end

 
  def help
  end
end
