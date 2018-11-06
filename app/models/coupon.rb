class Coupon < ApplicationRecord
	validates :code, presence: true, uniqueness: true
	validates :coupon_value, presence:true, numericality: true
	validates :min_order, presence: true, numericality: true
	validates :variety, presence: true

	enum variety: %w(percent amount)

	# if :variety == 1
	# 	validates :min_order, :numericality => {greater_than_or_equal_to: :coupon_value}
	# end
end