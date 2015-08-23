class HistoriesController < ApplicationController

  # GET /histories
  # GET /histories.json
  def index
    @histories = History.all
    @history = History.new 
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
      flash[:success] = "Histoiry created!"
      redirect_to root_path
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
      format.html { redirect_to histories_url }
      format.json { head :no_content }
    end
  end


 

end
