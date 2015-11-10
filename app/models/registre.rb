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

  attr_accessible :event_id, :history_id
  
  belongs_to :history
  belongs_to :event
  
  
  validates :history_id, presence: true
  validates :event_id, presence: true, uniqueness: { :scope => :history_id }

	def approve
		self.approved = true
	end

end
