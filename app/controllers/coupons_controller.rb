class CouponsController < ApplicationController
	require 'securerandom'

	def create

		if (coupon_params[:variety] == "1" && coupon_params[:min_order].to_f >= coupon_params[:coupon_value].to_f) || coupon_params[:variety] == "0"
			code = SecureRandom.uuid
			@coupon = Coupon.create(code: code, coupon_value: coupon_params[:coupon_value], min_order: coupon_params[:min_order], variety: coupon_params[:variety].to_i)
			if @coupon.save
				flash[:success] = "Coupon Successfully Created!"
				redirect_to dashboard_path
			else
				flash[:notice] = "Coupon was not created successfully. Please double-check input fields."
				redirect_to dashboard_path
			end

		else
			flash[:notice] = "**Coupon was not created successfully. Note: If Variety is 'dollars', Minimum Order must be greater than Coupon Value.**"
			redirect_to dashboard_path
		end
	end


	private

	def coupon_params
		params.require(:coupon).permit(:coupon_value, :min_order, :variety)
	end


end