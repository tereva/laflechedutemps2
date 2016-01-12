# == Schema Information
#
# Table name: histories
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class History < ActiveRecord::Base
  
  attr_accessible :description, :title

  belongs_to :user
  
  validates :title, presence: true
  #validates :description, presence: true
  validates :user_id, presence: true

  has_many :registres, foreign_key: "history_id", dependent: :destroy
  has_many  :events, through: :registres

 default_scope order: 'histories.created_at DESC'

end


def eventin?(event)
registres.find_by_event_id(event.id)
end
def eventin!(event)
registres.create!(event_id: event.id)
end

public 

def prepareData(color, path, action)
	tmp=[]
 	events = self.events.select("title, start, end, durationEvent, description, place, linked_history_id ")
  	events.each do |event|
  		link = (event.linked_history_id ?  path+event.linked_history_id.to_s+action : nil) 
	    tmp.push({:title => event.title, :start => event.start, :end => event.end,:place => event.place,
	    :durationEvent => event.durationEvent, :textColor=> color, :link => link, :description => event.description})
 	end
 	return tmp
end
