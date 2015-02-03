class History < ActiveRecord::Base
  attr_accessible :description, :title
  
  has_many :registres, foreign_key: "history_id", dependent: :destroy
  has_many  :events, through: :registres

end
