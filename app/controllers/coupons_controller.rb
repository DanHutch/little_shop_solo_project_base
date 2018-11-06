class CouponsController < ApplicationController
	require 'securerandom'

	def create
		if (coupon_params[:variety] == "amount" && coupon_params[:min_order] >= coupon_params[:coupon_value]) || coupon_params[:variety] == "percent"
			coupon_params[:code] = SecureRandom.uuid

			@coupon = Coupon.create(coupon_params)
			if @coupon.save
				flash[:success] = "Coupon Successfully Created!"
				redirect_to dashboard_path
			else
				flash[:notice] = "Coupon was not created successfully. Please double-check input fields."
			end
			
		else
			flash [:notice] = "Coupon was not created successfully. Note: If Variety is 'amount', Coupon Value must be greater than minimum order."
		end
	end


	private

	def coupon_params
		params.require(:coupon).permit(:coupon_value, :min_order, :variety)
	end


end