require 'rails_helper'

RSpec.describe "when a merchant wants to create a coupon code in their dashboard" do
	it "should allow a merchant to create a coupon" do 
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
	it "should not create a coupon with invalid inputs" do 
		merchant = User.create(email: "admin@admin.com", name: "admin", address: "123 street", city: "denver", state: "CO", zip: "00000", role: 1)

		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

		visit dashboard_path

		expect(page).to have_field("Coupon value")
		expect(page).to have_field("Min order")
		expect(page).to have_field("Variety")
		expect(page).to_not have_content("Active Coupons")

		fill_in "Coupon value", with: "10"
		fill_in "Min order", with: "5"
		select("dollars", from: 'Variety')
		click_on "Create Coupon"

		expect(page).to have_content("**Coupon was not created successfully. Note: If Variety is 'dollars', Minimum Order must be greater than Coupon Value.**")
		expect(page).to_not have_content("Active Coupons")

	
		fill_in "Min order", with: "5"
		select("dollars", from: 'Variety')
		click_on "Create Coupon"

		expect(page).to have_content("Coupon was not created successfully. Please double-check input fields.")
		expect(page).to_not have_content("Active Coupons")

	end
	it "should apply coupons to the cart" do
			merchant = User.create(email: "admin@admin.com", name: "admin", address: "123 street", city: "denver", state: "CO", zip: "00000", role: 1)
			customer = User.create(email: "customer@email.com", name: "Customer", address: "321 Ave", city: "Austin", state: "TX", zip: "11111", role: 0)
			item_1 = Item.create(name: "Item 1", description: "an item", price: 15, inventory: 100, user_id: merchant.id, image: "fdasdgsdf")
			merchant_2 = create(:merchant)
      active_item = create(:item, name: "Thingy", price: 30, user: merchant_2)

		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

		visit dashboard_path

		expect(page).to have_field("Coupon value")
		expect(page).to have_field("Min order")
		expect(page).to have_field("Variety")
		expect(page).to_not have_content("Active Coupons")

		fill_in "Coupon value", with: "10"
		fill_in "Min order", with: "15"
		
		click_on "Create Coupon"


		coupon = Coupon.create(code: "12345", coupon_value: 15, min_order: 20, variety: 1)

		expect(current_path).to eq(dashboard_path)
		expect(page).to have_content("Active Coupons")

		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(customer)

		visit items_path
		expect(current_path).to eq(items_path)
		click_on("Thingy")
		click_on "Add to Cart"
		visit cart_path
		click_on "Add 1"
		click_on "Add 1"

		expect(page).to have_field("Coupon code")
		fill_in "Coupon code", with: "#{coupon.code}"
		click_on "Apply"

	end
end