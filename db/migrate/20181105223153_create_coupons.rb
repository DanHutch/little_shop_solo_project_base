class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.integer :variety
      t.string :code
      t.float :coupon_value
      t.float :min_order, default: 0
    end
  end
end
