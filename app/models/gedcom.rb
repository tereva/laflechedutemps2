class Gedcom < ActiveRecord::Base
  attr_accessible :content, :name, :description, :public

  belongs_to :user

  validates :description, presence: true
  validates :name, presence: true
  validates :user_id, presence: true


end

public

def parse(color)

	pers = 0
	lines=0    
	birt=0
  deat=0

	person_log = []
	date_log = [] 
	all = []
	
	name=nil
	birtplace=nil
	birtdate=nil
	deatplace=nil
	deatdate=nil
  temp=nil
	date=nil
  sex = nil

	date_error = true

 	file = self.content.split("\n")
	file.each do |line|        
    lines+=1
    if  /0\x20\x40(I.*)\x40/.match(line) #nouvelle personne
      if pers>0 # enregistrer la precedente personne, sauf si c'est le premier  
        if !date_error # birtdate existe et au bon format
          all.push({:sex => sex, :ged => true, :title => name, :start=>  birtdate, :end => deatdate, :place => birtplace, 
            :durationEvent => deatdate ? true : false, :textColor => color })
        else
          person_log.push({:line => lines, :name => name })
        end
      end
      pers += 1
      birt=0
      deat=0
      name=nil
      birtplace=nil
      birtdate=nil
      deatplace=nil
      deatdate=nil
      date_error = true
      sex = nil
    elsif temp = /1\x20NAME\x20(.*)/.match(line) #nouvelle personne
      name = temp[1].gsub('/','')
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
          date.match(/\d{1,2}\s\D{3}\s\d{3,4}/) ? birtdate= DateTime.strptime(date , "%d %b %Y") : 
         (date.match(/\D{3}\s\d{3,4}/) ? birtdate= DateTime.strptime(date , "%b %Y") : 
             (  date.match(/\d{3,4}/) ? birtdate= DateTime.strptime(date , "%Y") : raise )
          )
          #case date
          #  when /\d{1,2}\s\D{3}\s\d{3,4}/
          #    birtdate= DateTime.strptime(date , "%d %b %Y")
          #  when /\D{3}\s\d{3,4}/
          #    birtdate= DateTime.strptime(date, "%b %Y")
          #  when /\d{3,4}/
          #    birtdate= DateTime.strptime(date , "%Y")
          #  else 
          #    date_error = true
          #   raise
          #end
          
        rescue Exception => exc
          date_log.push({:line => lines, :date => date }) 
          date_error = true
        end
      elsif deat==1 
        begin
          date = date[1].squish
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
          date_log.push({:line => lines, :date => date })
        end
      end     
    elsif place=/2\x20PLAC\x20(.*)/.match(line) # attribut lieu
      if birt==1
        birtplace=place[1]
      elsif deat==1
      deatplace=place[1]
      end

    elsif temp=/1\x20SEX\x20(.*)/.match(line) # attribut sex
      sex = temp[1].gsub('\x20','')
    end # if/0\x20\x40(I.*)\x40/.match(line)
  end # file.each

  if !date_error   
    all.push({:sex => sex, :ged => true, :title => name, :start=>  birtdate, :end => deatdate, :place => birtplace, 
            :durationEvent => deatdate ? true : false, :textColor => color})
   else
     person_log.push({:line => lines, :name => name })
  end

  [all, date_log, person_log, lines, pers]
end # parse


		
