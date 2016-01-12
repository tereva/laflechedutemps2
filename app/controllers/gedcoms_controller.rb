class GedcomsController < ApplicationController

  def upload

    if params[:file] 
 
      
      gedcom = current_user.gedcoms.new
      gedcom.name= params[:file].original_filename
      contents = File.open(params[:file].path, "r:iso8859-2"){ |file| file.read} 
      contents = contents.gsub("\r", "\n")
      gedcom.content = contents.gsub("\n\n", "\n")
      gedcom.public = params[:public] 

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
    if params[:utf8] # le formulaire est en cours...
      if params[:file] # upload temp le fichier
        gedcom = Gedcom.new
        contents = File.open(params[:file].path, "r:iso8859-2"){ |file| file.read}
        contents = contents.gsub("\r", "\n")
        gedcom.content = contents.gsub("\n\n", "\n")
        gedcom.name= params[:file].original_filename
      else # comparaison entre gedcom en base / histoire
        gedcom = Gedcom.find(params[:gedcom_id])
      end
      tmp, @date_log, @person_log = gedcom.parse("red")
      @path = gedcom.name
      @history=History.find(params[:history_id])
      resu = tmp + @history.prepareData("blue", "histories/","")
      @resu= resu.sort_by{|evt| evt[:start]}  
      @form=true
    end
  end  


 def show
    @gedcom = Gedcom.find(params[:id])
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

 
