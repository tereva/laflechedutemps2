class GedcomsController < ApplicationController

 before_filter :signed_admin, only: [:upload, :destroy]

  def upload

    if params[:file] 
 
      gedcom = current_user.gedcoms.new
      gedcom.name= params[:file].original_filename
      gedcom.content = ((File.open(params[:file].path, "r:iso8859-2"){ |f| 
            f.read}).gsub("\r", "\n")).gsub("\n\n", "\n")
      gedcom.public = params[:public] 
      gedcom.description = params[:description] 
      if gedcom.save
       flash[:success] = "Gedcom uploaded!"
       redirect_to root_path
      else
       flash[:notice] = "Error : Gedcom not recorded !"
       render 'gedcom/upload'
      end
    end
     
  end


  def compareHisGed
    @h = params[:history_id] ? params[:history_id] : History.first
    @g = params[:gedcom_id] ? params[:gedcom_id] : Gedcom.first
    if params[:utf8] # le formulaire est en cours...
      @history = History.find(@h)
      if params[:frise_button]
        if params[:file] 
          @gedcom_name= params[:file].original_filename
          @path = Rails.root.join('public', 'GEDCOM', @gedcom_name)
          File.open(@path, "wb") { |f| f.write(params[:file].read) }
          @timeline_req='http://localhost:3000/frise-history-gedcom?h='+@h.to_s+'&p='+@path.to_s
        else 
          @timeline_req='http://localhost:3000/frise-history-gedcom?h='+@h.to_s+'&g='+@g.to_s
          @gedcom_name= Gedcom.find(@g).name
        end
        render :layout => 'timeline_layout2', :template => 'gedcoms/frise'
      elsif params[:text_button] 
        if params[:file] 
          @gedcom = Gedcom.new
          @gedcom.content = ((File.open(params[:file].path, "r:iso8859-2"){ |f| 
            f.read}).gsub("\r", "\n")).gsub("\n\n", "\n")
          @gedcom.name= params[:file].original_filename
        else 
          @gedcom = Gedcom.find(@g)
        end
        tmp, @date_log, @person_log, @lines, @pers = @gedcom.parse("red")
        tmp += @history.prepareData("blue", "histories/","")
        @resu= tmp.sort_by{|evt| evt[:start]}
        #@resu=tmp
      end 
    end #utf8
  end # compareHisGed
        


  def showFriseHisGed

    if params[:g] # internal gedcom
      gedcom = Gedcom.find(params[:g])
    elsif params[:p] # uploaded gedcom in public/GEDCOM
      gedcom = Gedcom.new
      gedcom.content = ((File.open(params[:p], "r:iso8859-2"){ |f| 
            f.read}).gsub("\r", "\n")).gsub("\n\n", "\n")
      gedcom.name = params[:p]
    end
    tmp, date_log, person_log, lines, pers = gedcom.parse("red")
    history = History.find(params[:h])
    tmp += history.prepareData("blue", "histories/","/timeline")
    resu= tmp.sort_by{|evt| evt[:start]}
    data =  {'wiki-url'=>'http://simile.mit.edu/shelf',
        'wiki-section'=>'Simile Cubism Timeline',
        'dateTimeFormat'=>'Gregorian', 
        'events'=> resu } 
    render :json => data
  end


 def show
    @gedcom = Gedcom.find(params[:id])
    tmp, @date_log, @person_log, @lines, @pers = @gedcom.parse("black")
    @resu= tmp.sort_by{|evt| evt[:start]}
  end


  def destroy
    @gedcom = Gedcom.find(params[:id])
    @gedcom.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Suppression ok" }
      format.json { head :no_content }
    end
  end

end

 
