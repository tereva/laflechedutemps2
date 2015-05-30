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

require 'test_helper'

class ChronologyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
