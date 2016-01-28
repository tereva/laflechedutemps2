class GedcomsController < ApplicationController

 before_filter :signed_admin, only: [:upload, :destroy, :edit, :update]

 def upload

  if params[:file] 
   # check here if it s a gedcom file
    gedcom = current_user.gedcoms.new
    gedcom.name= sanitize_filename(params[:file].original_filename)
    gedcom.content = ((File.open(params[:file].path, "r:iso8859-2"){ |f| 
      f.read}).gsub("\r", "\n")).gsub("\n\n", "\n")
    gedcom.public = params[:public] 
    gedcom.description = params[:description] 
    if gedcom.save
     flash[:success] = "Gedcom uploaded!"
     redirect_to root_path
   else
     flash.now[:danger] = "Error : Gedcom not recorded !"
     render 'gedcom/upload'
   end
 end
 
end


def compareHisGed
  @h = params[:history_id] ? params[:history_id] : History.first
  @g = params[:gedcom_id] ? params[:gedcom_id] : Gedcom.first
  @ged_choice_default = false
    if params[:utf8] # le formulaire est en cours...
      @history = History.find(@h)
      @ged_choice_default = (params[:ged_choice] == '1') ? true : false 
      if params[:frise_button]
        if params[:file] 
        # we check here if it s a gedcom file (first line)
        begin
          first_line = File.open(params[:file].path, &:readline) 
          if ! /0\x20HEAD/.match(first_line) 
            flash.now[:warning] = "Warning : this is not a Gedcom file!"
            render 'compareHisGed'
          end
        rescue Exception => exc
          flash.now[:danger] = "Error : cannot upload this file"
          render 'compareHisGed'
        end
          # we "sanitize" the filename to prevent names like ../../name
          @gedcom_name= sanitize_filename(params[:file].original_filename)
          @path = Rails.root.join('public', 'GEDCOM', @gedcom_name)
          # upload in /public/GEDCOM
          File.open(@path, "wb") { |f| f.write(params[:file].read) }
          @timeline_req=root_url+'frise-history-gedcom?h='+@h.to_s+'&p='+@path.to_s
        else 
          @timeline_req=root_url+'frise-history-gedcom?h='+@h.to_s+'&g='+@g.to_s
          @gedcom_name= Gedcom.find(@g).name
        end
        render :layout => 'timeline_layout2', :template => 'gedcoms/frise'
      elsif params[:text_button] 
        if params[:file]  

        # check here if it s a gedcom file
        begin
          first_line = File.open(params[:file].path, &:readline)
          if ! /0\x20HEAD/.match(first_line) 
            flash.now[:warning] = "Warning : this is not a Gedcom file !"
            render 'compareHisGed'
          end
        rescue Exception => exc
          flash.now[:danger] = "Error : cannot upload this file"
          render 'compareHisGed'
        end 
          @gedcom = Gedcom.new
          @gedcom.content = ((File.open(params[:file].path, "r:iso8859-2"){ |f| 
            f.read}).gsub("\r", "\n")).gsub("\n\n", "\n")
          @gedcom_name= sanitize_filename(params[:file].original_filename)
          flash.now[:success] = "File was parsed with success"
        else 
          @gedcom = Gedcom.find(@g)
          @gedcom_name= @gedcom.name
        end
        tmp, @date_log, @person_log, @lines, @pers = @gedcom.parse("#ff6666")
        tmp += @history.prepareData("#6699ff", "/histories/","")
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


    def edit
      @gedcom = Gedcom.find(params[:id])
    end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @gedcom = Gedcom.find(params[:id])
    respond_to do |format|
      if @gedcom.update_attributes(params[:gedcom])
        format.html { redirect_to root_path, notice: 'Gedcom was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
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


