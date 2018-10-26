require 'rails_helper'

describe 'Site Navigation' do 
  context 'as a visitor' do
    it 'all links work' do 
      visit root_path

      click_link 'Home'
      expect(current_path).to eq(root_path)
      click_link 'Items'
      expect(current_path).to eq(items_path)
      click_link 'Merchants'
      expect(current_path).to eq(merchants_path)
      click_link 'Cart'
      expect(current_path).to eq(cart_path)
      click_link 'Login'
      expect(current_path).to eq(login_path)
      click_link 'Register'
      expect(current_path).to eq(register_path)
    end
  end

  context 'as a registered user' do 
    it 'all links work' do 
      visit root_path

      expect(page).to_not have_link(login_path)
      expect(page).to_not have_link(register_path)

      click_link 'Profile'
      expect(current_path).to eq(profile_path)
      click_link 'Orders'
      expect(current_path).to eq(profile_orders_path)
    end
  end

  context 'as a merchant' do 
    it 'all links work' do 
      visit root_path

      click_link 'Dashboard'
      expect(current_path).to eq(dashboard_path)
    end
  end

  context 'as an admin' do 
    it 'all links work' do 
      visit root_path

      click_link 'Dashboard'
      expect(current_path).to eq(dashboard_path)
      click_link 'Users'
      expect(current_path).to eq(users_path)
    end
  end
end