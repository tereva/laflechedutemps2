class Registre < ActiveRecord::Base
  belongs_to :history
  belongs_to :event
  
  attr_accessible :event_id, :history_id
  
  validates :history_id, presence: true
  validates :event_id, presence: true

end
