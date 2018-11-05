class Coupon < ApplicationRecord
validates :code, presence: true, uniqueness: true
validates :coupon_value, presence:true, numericality: true
validates :min_order, presence: true, numericality: true


enum variety: %w(percent amount amount_from)
end