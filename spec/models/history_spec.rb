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

require 'spec_helper'

describe History do

	before do
			 @history = History.new(title: "Histoire test", description: "Description histoire test")
	end

	it { should respond_to(:title) }
	it { should respond_to(:description) }
	it { should respond_to(:owner) }
	it { should respond_to(:status) }

	it { should be_valid }
end


