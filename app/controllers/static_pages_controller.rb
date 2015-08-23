class StaticPagesController < ApplicationController
 


  def home
  	@histories = History.all
  	if signed_in?
  		@myhistories = current_user.histories
  	end
  end

 

  def help
  end
end
