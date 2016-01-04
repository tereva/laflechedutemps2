require 'date'
#require 'FileUtils'

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


  def genealogy_timeline


  if params[:file] && params[:history_id]

    name = params[:file].original_filename
    directory = "public/GEDCOM"
    @path = File.join(directory, name)
    

    File.open(@path, "wb") { |f| f.write(params[:file].read) }

    #FileUtils.move params[:file].tempfile, @path

    
    flash[:notice] = "File uploaded"

    @history_id = params[:history_id]


   #contents = File.open(params[:file].path, "r:iso8859-2"){ |file| file.read}
   #local_filename = 'GEDCOM/file.ged'
   #File.open(local_filename, 'w') {|f| f.write(contents) }
   #File.syscopy(params[:file].path,'GEDCOM/file.ged' )
   # @path='http://localhost:3000/GEDCOM/db.ged'
   @form = true
   render :layout => 'genealogy_timeline_layout'
  end

  end




  def parse

    if params[:path] 
     #render params[:file].read
    
      @pers = 0
      @lines=0

      all = [] # futur array of hash
      date=nil
      temp=nil
      start=nil
      birt=0
      deat=0
      name='toto'
      birtplace=nil
      birtdate=nil
      deatplace=nil
      deatdate=nil
      date_error = false
      @date_log = []
      @debug = []

    #begin
      contents = File.open(params[:path], "r:iso8859-2"){ |file| file.read}
    #rescue
    #  @path = params[:path]
    #  @id = params[:history_id]
    # render 
    #end
      contents = contents.gsub("\r", "\n")
      contents = contents.gsub("\n\n", "\n")

      file = contents.split("\n")

      file.each do |line|        
        @lines+=1
        #@debug.push({:line => @lines, :content => line})

        if  /0\x20\x40(I.*)\x40/.match(line) #nouvelle personne

          if @pers>0 # enregistrer la precedente personne, sauf si c'est le premier  
            if !date_error && birtdate # birtdate doit exister obligatoirement
              all.push({:title => name, :start=>  birtdate, :end => deatdate, :place => birtplace, 
                :durationEvent => deatdate ? true : false, :textColor => "red"})
            else
              date_error = false
            end
          end
          @pers += 1
          birt=0
          deat=0
          name='toto'
          birtplace=nil
          birtdate=nil
          deatplace=nil
          deatdate=nil
        elsif temp = /1\x20NAME\x20(.*)/.match(line) #nouvelle personne
          name = temp[1]
        elsif /1\x20BIRT/.match(line) # evt naissance
          birt=1
          deat=0
        elsif /1\x20DEAT/.match(line) 
          deat=1
          birt=0
        elsif date=/2\x20DATE\x20(.*)/.match(line) # attribut date
          if birt==1 
            begin
            birtdate= DateTime.strptime(date[1] , "%d %b %Y") 
            rescue Exception => exc
              date_error=true
              @date_log.push({:line => @lines, :date => date[1] })
            end
          elsif deat==1 
            begin
              deatdate= DateTime.strptime(date[1] , "%d %b %Y")
            rescue Exception => exc
              date_error=true
              @date_log.push({:line => @lines, :date => date[1] })
            end
          end     
        elsif place=/2\x20PLAC\x20(.*)/.match(line) # attribut lieu
          if birt==1
            birtplace=place[1]
          elsif deat==1
          deatplace=place[1]
          end
        end # if/0\x20\x40(I.*)\x40/.match(line)
      end # file.each

      if !date_error  && birtdate  
        all.push({:title => name, :start=>  birtdate, :end => deatdate, :place => birtplace, 
                :durationEvent => deatdate ? true : false, :textColor => "red"})
      end

    end #if params[:file] 
   

    # selection de histoire
    if params[:history_id] 
      @history=History.find(params[:history_id])
      events = @history.events.select("title, start, end, durationEvent, description, place")
      @form=true
      events.each do |event|
        all.push({:title => event.title, :start => event.start, :end => event.end,:description => event.description,
        :durationEvent => event.durationEvent, :textColor=> "blue" })     
      end
      @all= all.sort_by{|hsh| hsh[:start]}

    data =  {'wiki-url'=>'http://simile.mit.edu/shelf',
        'wiki-section'=>'Simile Cubism Timeline',
        'dateTimeFormat'=>'Gregorian', 
        'events'=> @all} 

    render json: data
    end

  end # GENEALOGy


  def genealogy

    if params[:file] 
     #render params[:file].read
    
      @pers = 0
      @lines=0

      all = [] # futur array of hash
      date=nil
      temp=nil
      start=nil
      birt=0
      deat=0
      name='toto'
      birtplace=nil
      birtdate=nil
      deatplace=nil
      deatdate=nil
      date_error = false
      @date_log = []
      @debug = []

      @path = params[:file].path
      contents = File.open(params[:file].path, "r:iso8859-2"){ |file| file.read}

      contents = contents.gsub("\r", "\n")
      contents = contents.gsub("\n\n", "\n")

      file = contents.split("\n")

      file.each do |line|        
        @lines+=1
        #@debug.push({:line => @lines, :content => line})

        if  /0\x20\x40(I.*)\x40/.match(line) #nouvelle personne

          if @pers>0 # enregistrer la precedente personne, sauf si c'est le premier  
            if !date_error && birtdate # birtdate doit exister obligatoirement
              all.push({:title => name, :start=>  birtdate, :end => deatdate, :place => birtplace, 
                :durationEvent => deatdate ? true : false, :textColor => "red", :link => nil })
            else
              date_error = false
            end
          end
          @pers += 1
          birt=0
          deat=0
          name='toto'
          birtplace=nil
          birtdate=nil
          deatplace=nil
          deatdate=nil
        elsif temp = /1\x20NAME\x20(.*)/.match(line) #nouvelle personne
          name = temp[1]
        elsif /1\x20BIRT/.match(line) # evt naissance
          birt=1
          deat=0
        elsif /1\x20DEAT/.match(line) 
          deat=1
          birt=0
        elsif date=/2\x20DATE\x20(.*)/.match(line) # attribut date
          if birt==1 
            begin
              #birtdate= DateTime.strptime(date[1] , "%d %b %Y")
              date[1].match(/\s/) ? birtdate= DateTime.strptime(date[1] , "%d %b %Y") : 
                    birtdate= DateTime.strptime(date[1] , "%Y")
            rescue Exception => exc
              date_error=true
              @date_log.push({:line => @lines, :date => date[1] })
            end
          elsif deat==1 
            begin
              date[1].match(/\s/) ? deatdate= DateTime.strptime(date[1] , "%d %b %Y") : 
                    deatdate= DateTime.strptime(date[1] , "%Y")

              #deatdate= DateTime.strptime(date[1] , "%d %b %Y")
            rescue Exception => exc
              date_error=true
              @date_log.push({:line => @lines, :date => date[1] })
            end
          end     
        elsif place=/2\x20PLAC\x20(.*)/.match(line) # attribut lieu
          if birt==1
            birtplace=place[1]
          elsif deat==1
          deatplace=place[1]
          end
        end # if/0\x20\x40(I.*)\x40/.match(line)
      end # file.each

      if !date_error  && birtdate  
        all.push({:title => name, :start=>  birtdate, :end => deatdate, :place => birtplace, 
                :durationEvent => deatdate ? true : false, :textColor => "red"})
      end

    end #if params[:file] 
   

    # selection de histoire
    if params[:history1_id] 
      @history1=History.find(params[:history1_id])
      events = @history1.events.select("title, start, end, durationEvent, description, place, linked_history_id ")
      @form=true
      events.each do |event|
        #link="#"
        #if event.durationEvent 
        # if event.linked_history_id 
        #   link = "http://localhost:3000/histories/"+event.linked_history_id.to_s
        #  end
        #end
        all.push({:title => event.title, :start => event.start, :end => event.end,:place => event.place,
        :durationEvent => event.durationEvent, :textColor=> "blue", :link => event.linked_history_id, 
        :description => event.description
      })
      end
      @all= all.sort_by{|hsh| hsh[:start]}

    data =  {'wiki-url'=>'http://simile.mit.edu/shelf',
        'wiki-section'=>'Simile Cubism Timeline',
        'dateTimeFormat'=>'Gregorian', 
        'events'=> @all} 

    #render json: data
    end

  end # GENEALOGy


end # class




