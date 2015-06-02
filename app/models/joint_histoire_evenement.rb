# == Schema Information
#
# Table name: joint_histoire_evenements
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  history_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class JointHistoireEvenement < ActiveRecord::Base
  belongs_to :event
  attr_accessible :history
end
