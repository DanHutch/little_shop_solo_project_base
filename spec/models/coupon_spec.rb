require 'rails_helper'

RSpec.describe Coupon, type: :model do
	describe 'validations' do
		it {should validate_presence_of :code }
		it {should validate_presence_of :coupon_value }
		it {should validate_presence_of :min_order }
		it {should validate_numericality_of :min_order }
		it {should validate_numericality_of :coupon_value }
		it {should validate_uniqueness_of :code }
	end
end