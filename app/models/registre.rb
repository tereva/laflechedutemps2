# == Schema Information
#
# Table name: registres
#
#  id         :integer         not null, primary key
#  history_id :integer
#  event_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Registre < ActiveRecord::Base
  belongs_to :history
  belongs_to :event
  
  attr_accessible :event_id, :history_id
  
  validates :history_id, presence: true
  validates :event_id, presence: true

end
