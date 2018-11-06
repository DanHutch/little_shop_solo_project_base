require 'rails_helper'


RSpec.describe Coupon, type: :model do
	describe 'validations' do
		it {should validate_presence_of :code }
		it {should validate_presence_of :coupon_value }
		it {should validate_presence_of :min_order }
		it {should validate_presence_of :variety }
		it {should validate_numericality_of :min_order }
		it {should validate_numericality_of :coupon_value }
		it {should validate_uniqueness_of :code }
	end
	it "should successfully create a coupon" do
		expect(Coupon.all.size).to eq(0)
		code = SecureRandom.uuid
		coupon = Coupon.create(code: code, coupon_value: 10, min_order: 20, variety: 1)

		expect(coupon.code).to eq(code)
		expect(coupon.coupon_value).to eq(10)
		expect(coupon.min_order).to eq(20)
		expect(coupon.variety).to eq("dollars")
		expect(Coupon.all.size).to eq(1)

	end
	it "should successfully create a coupon even without giving it a minimum order amount" do
		expect(Coupon.all.size).to eq(0)
		code = SecureRandom.uuid
		coupon = Coupon.create(code: code, coupon_value: 10, variety: 1)

		expect(coupon.code).to eq(code)
		expect(coupon.coupon_value).to eq(10)
		expect(coupon.min_order).to eq(0)
		expect(coupon.variety).to eq("dollars")
		expect(Coupon.all.size).to eq(1)
	end
	it "should not create a coupon if the min order amount is less than zero" do
		expect(Coupon.all.size).to eq(0)
		code = SecureRandom.uuid
		coupon = Coupon.create(code: code, coupon_value: 10, min_order: -5, variety: 1)

		expect(Coupon.all.size).to eq(0)
	end

	# it "should not create a coupon with a value greater than the minimum order" do
	# 	expect(Coupon.all).to eq([])
	# 	code = SecureRandom.uuid
	# 	coupon = Coupon.create(code: code, coupon_value: 30, min_order: 20, variety: 1)
	# 	expect(Coupon.all).to eq([])

	# end
end