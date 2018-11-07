require 'rails_helper'

RSpec.describe "when a merchant wants to create a coupon code in their dashboard" do
	it "should have input fields to create a coupon" do 
		merchant = User.create(email: "admin@admin.com", name: "admin", address: "123 street", city: "denver", state: "CO", zip: "00000", role: 1)

		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

		visit dashboard_path

		expect(page).to have_field("Coupon value")
		expect(page).to have_field("Min order")
		expect(page).to have_field("Variety")
		expect(page).to_not have_content("Active Coupons")

		fill_in "Coupon value", with: "10"
		fill_in "Min order", with: "15"
		click_on "Create Coupon"

		expect(current_path).to eq(dashboard_path)
		expect(page).to have_content("Active Coupons")
	end
end