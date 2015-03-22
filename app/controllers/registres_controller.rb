class RegistresController < ApplicationController

  def create
  @history= History.find(params[:history_id])
  @event = Event.find(params[:event_id])
  @history.registres.create(event_id:@event.id)
#   @history.registres.create(event:@event)
  respond_to do |format|
   format.html { redirect_to edit_history_path(@history.id) }
   format.js
  end
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

end
