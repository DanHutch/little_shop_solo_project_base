class Coupon < ApplicationRecord
	validates :code, presence: true, uniqueness: true
	validates :coupon_value, presence:true, numericality: true
	validates :min_order, presence: true, numericality: true
	validates :min_order, :numericality => {greater_than_or_equal_to: 0}
	validates :variety, presence: true

	def self.varieties
		%w(percent dollars)
	end

	enum variety: Coupon.varieties


	# if :variety == 1
	# 	validates :min_order, :numericality => {greater_than_or_equal_to: :coupon_value}
	# end
end