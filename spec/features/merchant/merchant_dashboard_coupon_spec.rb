require 'rails_helper'

RSpec.describe "when a merchant wants to create a coupon code in their dashboard" do
	it "should have input fields to create a coupon" do 
		merchant = User.create(email: admin@admin.com, name: "admin", address: "123 street", city: "denver", state: "CO", zip: "00000", role: 1)

		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

		visit dashboard_path

		expect(page).to have_field("Coupon Value")
		expect(page).to have_field("Minimum Order Amount")
		# expect(page).to have_field("Variety")
		
	end
end