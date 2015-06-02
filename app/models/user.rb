# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  
  # magique : fait le lien avec la colonne password_digest de la base 
  has_secure_password


  # mise en minuscule avant sauvegarde dans la base
  before_save { |user| user.email = email.downcase }


  validates :name, presence: true, length: { maximum: 50 }

  # Regex qui donne le format standard possible pour l'email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # email n'est pas sensible à la case
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  				uniqueness: { case_sensitive: false }

validates :password, presence: true, length: { minimum: 6 }
validates :password_confirmation, presence: true
 				

end
