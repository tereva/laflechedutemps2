class Chronology < ActiveRecord::Base
  belongs_to :event
  attr_accessible :title
end
