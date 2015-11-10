class RegistresController < ApplicationController

before_filter :signed_user, only: [:create]
before_filter :signed_admin, only: [:destroy, :toggle_approve]

  def create

  @registre=Registre.new(history_id:params[:history_id],event_id:params[:event_id] )
  if @registre.save
      if current_user.admin 
          @registre.toggle!(:approved)
      end
      flash[:success] = "Event added to history!"
       redirect_to edit_history_path params[:history_id]
    else
      render 'histories/index'
   end

  #@history= History.find(params[:history_id])
  #@event = Event.find(params[:event_id])
  #@history.registres.create(event_id:@event.id)
  #respond_to do |format|
  # format.html { redirect_to edit_history_path(@history.id) }
  # format.js
  #end
 end

 def destroy
   @registre=Registre.find(params[:id])
   @history_id=@registre.history_id
   @registre.destroy

#  @event = Event.find(params[:event][:event_id])
#  @history.registres.find_by_event_id(@event.id).destroy
#  @history.registres.delete(@event)
  respond_to do |format|
   format.html { redirect_to edit_history_path(@history_id) }
   format.js
  end
 
end

def toggle_approve
    @registre2=Registre.find(params[:id])
    @registre2.toggle!(:approved)
    if !@registre2.history.approved 
      @registre2.history.toggle!(:approved)  
    end
    if !@registre2.event.approved 
      @registre2.event.toggle!(:approved)  
    end
    respond_to do |format|
      format.js
    end
end
end
