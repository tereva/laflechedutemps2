namespace :db do
 desc "Fill database with sample data"
 task populate: :environment do
 make_events
 make_histories
 make_registres
 end
end

def make_events
 50.times do
   title = Faker::Name.name
   debut = rand(1.year).ago
   lieu = Faker::Address.city
   desc = Faker::Lorem.sentence(5)
   Event.create!(title:       title,
                 start:       debut,
                 place:       lieu, 
                 description: desc)  
 end
end

def make_histories
 5.times do
  
   title = Faker::Name.name
   desc = Faker::Lorem.sentence(5)
   History.create!(title:title, description:desc)
 
 end
end


def make_registres
 5.times do |n|
  30.times do
   idevent = rand(51-1)
   idhistory = n+1
   Registre.create(history_id:idhistory, event_id:idevent)
  end
 end
end
