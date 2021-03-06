require 'date'
#require 'FileUtils'

class StaticPagesController < ApplicationController
 
def index
render :layout => 'one_page_layout'
end

def home

 @histories_block_five = History.where(approved: true).limit(5)
 @events_block_five = Event.where(approved: true).limit(5)
 @gedcoms_block_five= Gedcom.where(approved: true, public: true).limit(5)
   if signed_admin?
    @histories_block_admin = History.where(approved: false)
    @registres_block_admin = Registre.where(approved: false)
    @events_block_admin = Event.where(approved: false)
    @gedcoms_block_admin= Gedcom.where(approved: false)

  end
  if signed_in?
    @histories_block_contrib = current_user.histories
    @gedcoms_block_contrib = current_user.gedcoms
    @registres_block_contrib = current_user.registres
    @events_block_contrib = current_user.events
  end
  render :layout => 'home_layout'
end

 
  def help
  end

  def genealogy_timeline

  if params[:file] && params[:history_id]

    @name = params[:file].original_filename
    directory = "public/GEDCOM"
    @path = File.join(directory, @name)
    

    File.open(@path, "wb") { |f| f.write(params[:file].read) }

    #FileUtils.move params[:file].tempfile, @path

    
    flash[:notice] = "File uploaded"

    @history_id = params[:history_id]

    @request = "http://localhost:3000/parse?path=" + @path +"&history_id="+@history_id.to_s
    @history = History.find(params[:history_id])


   #contents = File.open(params[:file].path, "r:iso8859-2"){ |file| file.read}
   #local_filename = 'GEDCOM/file.ged'
   #File.open(local_filename, 'w') {|f| f.write(contents) }
   #File.syscopy(params[:file].path,'GEDCOM/file.ged' )
   # @path='http://localhost:3000/GEDCOM/db.ged'
   @form = true
   render :layout => 'genealogy_timeline_layout'
  end

  end




  def parse2

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


      contents = File.open(params[:path], "r:iso8859-2"){ |file| file.read}

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
                :durationEvent => deatdate ? true : false, :textColor => "red" })
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
    if params[:history_id] 
      @history1=History.find(params[:history_id])
      events = @history1.events.select("title, start, end, durationEvent, description, place, linked_history_id ")
      @form=true
      events.each do |event|
        #link="#"
        #if event.durationEvent 
        # if event.linked_history_id 
        #   link = "http://localhost:3000/histories/"+event.linked_history_id.to_s
        #  end
        #end

      if event.linked_history_id
          all.push({:title => event.title, :start => event.start, :end => event.end,:description => event.description,
        :durationEvent => event.durationEvent, :link => timeline_history_path(event.linked_history_id), :textColor=> "blue"})    
      else
          all.push({:title => event.title, :start => event.start, :end => event.end,:description => event.description,
          :durationEvent => event.durationEvent, :textColor=> "blue"})
      end

      end
      @all= all.sort_by{|hsh| hsh[:start]}

  

    data =  {'wiki-url'=>'http://simile.mit.edu/shelf',
        'wiki-section'=>'Simile Cubism Timeline',
        'dateTimeFormat'=>'Gregorian', 
        'events'=> @all} 

    render json: data
    end

  end # GENEALOGy

  def genealogy # comparaison fusion txt

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
      @person_log = []
      @debug = []
      date_error = true

      @path= params[:file].original_filename
      contents = File.open(params[:file].path, "r:iso8859-2"){ |file| file.read} 


      contents = contents.gsub("\r", "\n")
      contents = contents.gsub("\n\n", "\n")

      #gedcom = current_user.gedcoms.create(name: @path, content: contents, public: true)

      file = contents.split("\n")

      file.each do |line|        
        @lines+=1
        #@debug.push({:line => @lines, :content => line})

        if  /0\x20\x40(I.*)\x40/.match(line) #nouvelle personne

          if @pers>0 # enregistrer la precedente personne, sauf si c'est le premier  
            if !date_error # birtdate existe et au bon format
              all.push({:title => name, :start=>  birtdate, :end => deatdate, :place => birtplace, 
                :durationEvent => deatdate ? true : false, :textColor => "red" })
            else
              @person_log.push({:line => @lines, :name => name })
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
          date_error = true
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
               date = date[1].squish
               date_error = false
              # date.match(/\d{1,2}\s\D{3}\s\d{3,4}/) ? birtdate= DateTime.strptime(date , "%d %b %Y") : 
              #      (date.match(/\D{3}\s\d{3,4}/) ? birtdate= DateTime.strptime(date , "%b %Y") : 
              #          (  date.match(/\d{3,4}/) ? birtdate= DateTime.strptime(date , "%Y") : raise )
              #       )
              
              case date
                when /\d{1,2}\s\D{3}\s\d{3,4}/
                  birtdate= DateTime.strptime(date , "%d %b %Y")
                when /\D{3}\s\d{3,4}/
                  birtdate= DateTime.strptime(date, "%b %Y")
                when /\d{3,4}/
                  birtdate= DateTime.strptime(date , "%Y")
                else 
                  raise
              end
              
            rescue Exception => exc
              date_error = true
              @date_log.push({:line => @lines, :date => date })
            end
          elsif deat==1 
            begin
              date = date[1].squish
            #   date.match(/\d{1,2}\s\D{3}\s\d{3,4}/) ? deatdate= DateTime.strptime(date , "%d %b %Y") : 
            #        (date.match(/\D{3}\s\d{3,4}/) ? deatdate= DateTime.strptime(date, "%b %Y") : 
            #             ( date.match(/\d{3,4}/) ? deatdate= DateTime.strptime(date , "%Y") : raise)
            #         )
            
             case date
             when /\d{1,2}\s\D{3}\s\d{3,4}/
               deatdate= DateTime.strptime(date , "%d %b %Y")
            when /\D{3}\s\d{3,4}/
               deatdate= DateTime.strptime(date, "%b %Y")
             when /\d{3,4}/
               deatdate= DateTime.strptime(date , "%Y")
             else 
               raise
            end

            rescue Exception => exc
              @date_log.push({:line => @lines, :date => date })
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

      if !date_error   
        all.push({:title => name, :start=>  birtdate, :end => deatdate, :place => birtplace, 
                :durationEvent => deatdate ? true : false, :textColor => "red"})
      end

    end #if params[:file] 
   

    # selection de histoire
    if params[:history_id] 
      @history=History.find(params[:history_id])
      events = @history.events.select("title, start, end, durationEvent, description, place, linked_history_id ")
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
      #@all= all
    data =  {'wiki-url'=>'http://simile.mit.edu/shelf',
        'wiki-section'=>'Simile Cubism Timeline',
        'dateTimeFormat'=>'Gregorian', 
        'events'=> @all} 

    #render json: data
    end

  end # GENEALOGy


end # class




