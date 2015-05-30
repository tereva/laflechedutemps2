# == Schema Information
#
# Table name: chronologies
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  event_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Chronology < ActiveRecord::Base
  belongs_to :event
  attr_accessible :title
end
