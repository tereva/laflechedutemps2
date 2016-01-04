class HistoriesController < ApplicationController

 before_filter :signed_user, only: [:edit, :update, :new, :create, :destroy]
 before_filter :can_delete, only: [:destroy]
 before_filter :correct_history2,  only: [:edit, :update, :show]

  # GET /histories
  # GET /histories.json
  def index
    @histories = History.where(approved: true)
  end

  # GET /histories/1
  # GET /histories/1.json
  def show
    @history = History.find(params[:id])
    @events = @history.events.paginate(page: params[:page])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @history }
    end
  end

  def timeline
   @history = History.find(params[:id])
   render :layout => 'timeline_layout'
  end

  
  def jsonized
   @history = History.find(params[:id])
   events = @history.events.select("title, start, end, durationEvent, description, place, linked_history_id")
   all=[]
   events.each do |event|
    if event.linked_history_id
      all.push({:title => event.title, :start => event.start, :end => event.end,:description => event.description,
        :durationEvent => event.durationEvent, :link => timeline_history_path(event.linked_history_id)})    
    else
      all.push({:title => event.title, :start => event.start, :end => event.end,:description => event.description,
        :durationEvent => event.durationEvent})
    end
  end

  @data =  {'wiki-url'=>'http://simile.mit.edu/shelf',
        'wiki-section'=>'Simile Cubism Timeline',
        'dateTimeFormat'=>'Gregorian', 
        'events'=> all, } 

    #@data =  {title: @history.title,  description: @history.description} 
    render json: @data
  end


  # GET /histories/new
  # GET /histories/new.json
  def new
    @history = History.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @history }
    end
  end

  # GET /histories/1/edit
  def edit
    @history = History.find(params[:id])
    #@events = @history.events.paginate(page: params[:page])
    #@event=Event.all
    #@registre = @history.registres.build
  end

  def create
    @history = current_user.histories.build(params[:history])
    if @history.save
      if current_user.admin 
          @history.toggle!(:approved)
      end
      flash[:success] = "History created!"
       redirect_to edit_history_path @history.id
    else
      render 'histories/index'

    end
  end

  # PUT /histories/1
  # PUT /histories/1.json
  def update
    @history = History.find(params[:id])

    respond_to do |format|
      if @history.update_attributes(params[:history])
        format.html { redirect_to edit_history_path @history.id, notice: 'History was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /histories/1
  # DELETE /histories/1.json
  def destroy
    @history = History.find(params[:id])
    @history.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Suppression ok" }
      format.json { head :no_content }
    end
  end


  def compare
    if params[:history1_id] && params[:history2_id]
      
      @history1=History.find(params[:history1_id])
      @history2=History.find(params[:history2_id])
  
      @indice1=History.find(params[:history1_id]).event_ids
      @indice2=History.find(params[:history2_id]).event_ids

      @indice3=@indice1+@indice2

      @event1=Event.where(:id => @indice1+@indice2)
     
     # @event1=Event.where(:id => @indice1).order('start DESC') 
     # @events_1 = @history1.events.select("title, start, end, durationEvent, description")
     

    end



  end

private

def correct_history
  if current_user
    @history = History.find(params[:id])
    redirect_to root_path, notice: "Action impossible" unless (current_user.admin || @history.approved  || (!@history.approved && current_user.id == @history.user_id  ))
  end 
end

def correct_history2
@history = History.find(params[:id])
redirect_to root_path, notice: "error : Action impossible" unless (@history.approved ||  signed_admin? || owner?(@history))
end



def can_delete
@history = History.find(params[:id])
redirect_to root_path, notice: "error : Action impossible" unless (signed_admin? || (owner?(@history) && !@history.approved))
end


end

 
