class Event < ActiveRecord::Base
  attr_accessible :description, :durationEvent, :end, :place, :start, :title
   
 # before_save { |event| event.title = title.downcase }
 # validates :title, presence: true, uniqueness: {case_sensitive: false}
  
  validates :title, presence: true
  validates :start, presence: true
  validates :place, presence: true

  has_many :registres, foreign_key: "event_id", dependent: :destroy
  has_many  :histories, through: :registres

end


