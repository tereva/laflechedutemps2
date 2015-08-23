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
  
  attr_accessible :description, :title, :approved

  belongs_to :user
  
  validates :title, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  has_many :registres, foreign_key: "history_id", dependent: :destroy
  has_many  :events, through: :registres

end


def eventin?(event)
registres.find_by_event_id(event.id)
end
def eventin!(event)
registres.create!(event_id: event.id)
end

