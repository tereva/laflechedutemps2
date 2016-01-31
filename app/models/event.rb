# == Schema Information
#
# Table name: events
#
#  id            :integer         not null, primary key
#  title         :string(255)
#  start         :datetime
#  end           :datetime
#  durationEvent :boolean
#  place         :string(255)
#  description   :text
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  validated     :boolean
#

class Event < ActiveRecord::Base
  attr_accessible :title, :start, :end, :durationEvent, :place,:description, :linked_history_id
   belongs_to :user
   
 # before_save { |event| event.title = title.downcase }
 # validates :title, presence: true, uniqueness: {case_sensitive: false}
  
  validates :title, presence: true
  validates :start, presence: true
  validates :place, presence: true
  validates :user_id, presence: true

  has_many :registres, foreign_key: "event_id", dependent: :destroy
  has_many  :histories, through: :registres



default_scope order: 'events.updated_at DESC'

  def self.import(file, history_id, user_id)
  	CSV.foreach(file.path, headers: true) do |row|

      event = find_by_id(row["id"]) || new
      event.attributes = row.to_hash.slice(*accessible_attributes)
      event.user_id = user_id
      event.approved = true
      event.save!
      registre = event.registres.new
      registre.history_id = history_id
      registre.approved = true
      registre.save!

  	end
  end


  

end


