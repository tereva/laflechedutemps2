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

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
