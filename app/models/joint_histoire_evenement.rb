class JointHistoireEvenement < ActiveRecord::Base
  belongs_to :event
  attr_accessible :history
end
