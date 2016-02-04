class EventsController < ApplicationController

  before_filter :signed_user, only: [:new, :create, :edit, :update, :destroy]
  before_filter :signed_admin, only: [:import, :toggle_approve]
  before_filter :can_modify_event,  only: [:edit, :update, :destroy] 
  before_filter :can_show_event,  only: [:show] 


  # GET /events
  # GET /events.json
  def index
    @events = Event.where(approved: true)
    @events = @events.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    #@event = Event.new(params[:event])
    @event= current_user.events.build(params[:event])

    respond_to do |format|
      if @event.save
         if current_user.admin 
          @event.toggle!(:approved)
      end
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def import
    Event.import(params[:file], params[:history_id], current_user.id)
    redirect_to events_url, notice: "Events imported"
  end


def toggle_approve
    @event2=Event.find(params[:id])
    @event2.toggle!(:approved)
    respond_to do |format|
      format.js
    end
end

private 


def can_modify_event
@event= Event.find(params[:id])
redirect_to root_path, notice: "Event Error Edit/Update/Delete : Action impossible" unless (signed_admin? || (owner?(@event) && !@event.approved))
end

def can_show_event
@event= Event.find(params[:id])
redirect_to root_path, notice: "Event Error Show : Action impossible" unless (@event.approved || signed_admin? || owner?(@event))
end

end
