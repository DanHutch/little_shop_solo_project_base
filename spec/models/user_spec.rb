require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Relationships' do
    it { should have_many(:orders) }
    it { should have_many(:items) }
  end

  describe 'Validations' do 
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe 'Class Methods' do
    it '.top_merchants(quantity)' do
      user = create(:user)
      merchant_1, merchant_2, merchant_3, merchant_4 = create_list(:merchant, 4)
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)
      item_3 = create(:item, user: merchant_3)
      item_4 = create(:item, user: merchant_4)

      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item_1, price: 20000, quantity: 1)

      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item_2, price: 2000, quantity: 1)

      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item_3, price: 200000, quantity: 1)

      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item_4, price: 200, quantity: 1)

      expect(User.top_merchants(4)).to eq([merchant_3, merchant_1, merchant_2, merchant_4])
    end
    it '.popular_merchants(quantity)' do
      user = create(:user)
      merchant_1, merchant_2, merchant_3, merchant_4 = create_list(:merchant, 4)
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)
      item_3 = create(:item, user: merchant_3)
      item_4 = create(:item, user: merchant_4)

      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1)

      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)

      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 1)

      order = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)

      expect(User.popular_merchants(3)).to eq([merchant_2, merchant_1, merchant_3])
    end
    context 'merchants by speed' do
      before(:each) do
        user = create(:user)
        @merchant_1, @merchant_2, @merchant_3, @merchant_4 = create_list(:merchant, 4)
        item_1 = create(:item, user: @merchant_1)
        item_2 = create(:item, user: @merchant_2)
        item_3 = create(:item, user: @merchant_3)
        item_4 = create(:item, user: @merchant_4)

        order = create(:order, user: user)
        create(:fulfilled_order_item, order: order, item: item_1, created_at: 1.year.ago)
        create(:fulfilled_order_item, order: order, item: item_2, created_at: 10.days.ago)
        create(:order_item, order: order, item: item_3, price: 3, quantity: 1)
        create(:fulfilled_order_item, order: order, item: item_4, created_at: 3.seconds.ago)
      end
      it '.fastest_merchants(quantity)' do
        expect(User.fastest_merchants(4)).to eq([@merchant_4, @merchant_2, @merchant_1, @merchant_3])
      end
      it '.slowest_merchants(quantity)' do
        expect(User.slowest_merchants(4)).to eq([@merchant_3, @merchant_1, @merchant_2, @merchant_4])
      end
    end
  end

  describe 'Instance Methods' do 
    it '.merchant_items' do
      user = create(:user)
      merchant = create(:merchant)
      item_1, item_2, item_3, item_4, item_5 = create_list(:item, 5, user: merchant)
      
      order_1 = create(:order, user: user)
      create(:order_item, order: order_1, item: item_1)
      create(:order_item, order: order_1, item: item_2)
  sleep(2)
      order_2 = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order_2, item: item_2)
      create(:fulfilled_order_item, order: order_2, item: item_3)

      expect(merchant.merchant_orders).to eq([order_1, order_2])
    end
    it '.merchant_items(:pending)' do
      user = create(:user)
      merchant = create(:merchant)
      item_1, item_2, item_3, item_4, item_5 = create_list(:item, 5, user: merchant)
      
      order_1 = create(:order, user: user)
      create(:order_item, order: order_1, item: item_1)
      create(:order_item, order: order_1, item: item_2)
  
      order_2 = create(:completed_order, user: user)
      create(:fulfilled_order_item, order: order_2, item: item_2)
      create(:fulfilled_order_item, order: order_2, item: item_3)

      expect(merchant.merchant_orders(:pending)).to eq([order_1])
    end
    it '.merchant_for_order(order)' do 
      user = create(:user)
      merchant_1, merchant_2 = create_list(:merchant, 2)
      item_1, item_2 = create_list(:item, 5, user: merchant_1)
      item_3, item_4 = create_list(:item, 5, user: merchant_2)
      
      order_1 = create(:order, user: user)
      create(:order_item, order: order_1, item: item_1)
      create(:order_item, order: order_1, item: item_2)
  
      order_2 = create(:order, user: user)
      create(:order_item, order: order_2, item: item_3)
      create(:order_item, order: order_2, item: item_4)

      expect(merchant_1.merchant_for_order(order_1)).to eq(true)
      expect(merchant_1.merchant_for_order(order_2)).to eq(false)
    end
    it '.total_items_sold' do
      user = create(:user)
      merchant_1, merchant_2 = create_list(:merchant, 2)
      item_1, item_2 = create_list(:item, 5, user: merchant_1)
      item_3, item_4 = create_list(:item, 5, user: merchant_2)
      
      order_1 = create(:completed_order, status: :completed, user: user)
      oi_1 = create(:fulfilled_order_item, order: order_1, item: item_1)
      oi_2 = create(:fulfilled_order_item, order: order_1, item: item_3)
  
      order_2 = create(:order, user: user)
      oi_3 = create(:fulfilled_order_item, order: order_2, item: item_2)
      oi_4 = create(:order_item, order: order_2, item: item_4)

      expect(merchant_1.total_items_sold).to eq(oi_1.quantity + oi_3.quantity)
      expect(merchant_2.total_items_sold).to eq(oi_2.quantity)
    end
    it '.total_inventory' do
      merchant = create(:merchant)
      item_1, item_2 = create_list(:item, 2, user: merchant)

      expect(merchant.total_inventory).to eq(item_1.inventory + item_2.inventory)
    end
    it '.top_3_shipping_states' do
      user_1 = create(:user, state: 'CO')
      user_2 = create(:user, state: 'CA')
      user_3 = create(:user, state: 'FL')
      user_4 = create(:user, state: 'NY')

      merchant = create(:merchant)
      item_1 = create(:item, user: merchant)

      # Colorado is 1st place
      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1)
      # California is 2nd place
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)
      # Sorry Florida
      order = create(:completed_order, user: user_3)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_4)
      # NY is 3rd place
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_4)
      create(:fulfilled_order_item, order: order, item: item_1)

      expect(merchant.top_3_shipping_states).to eq(['CO', 'CA', 'NY'])
    end
    it '.top_3_shipping_cities' do
      user_1 = create(:user, city: 'Denver')
      user_2 = create(:user, city: 'Houston')
      user_3 = create(:user, city: 'Ottawa')
      user_4 = create(:user, city: 'NYC')

      merchant = create(:merchant)
      item_1 = create(:item, user: merchant)

      # Denver is 2nd place
      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1)
      # Houston is 1st place
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)
      # Sorry Ottawa
      order = create(:completed_order, user: user_3)
      create(:fulfilled_order_item, order: order, item: item_1)
      # NYC is 3rd place
      order = create(:completed_order, user: user_4)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_4)
      create(:fulfilled_order_item, order: order, item: item_1)

      expect(merchant.top_3_shipping_cities).to eq(['Houston', 'Denver', 'NYC'])
    end
    it '.top_active_user' do
      user_1 = create(:user, city: 'Denver')
      user_2 = create(:user, city: 'Houston')
      merchant = create(:merchant)
      item_1 = create(:item, user: merchant)

      # user 1 is in 2nd place
      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1)
      # user 2 is best to start
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)
      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1)

      expect(merchant.top_active_user).to eq(user_2)
      user_2.update(active: false)
      expect(merchant.top_active_user).to eq(user_1)
    end
    it '.biggest_order' do
      user_1 = create(:user, city: 'Denver')
      user_2 = create(:user, city: 'Houston')
      merchant_1, merchant_2 = create_list(:merchant, 2)
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)

      # user 1 is in 2nd place
      order_1 = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, quantity: 10, order: order_1, item: item_1)
      create(:fulfilled_order_item, order: order_1, item: item_2)
      # user 2 is best to start
      order_2 = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, quantity: 100, order: order_2, item: item_1)
      create(:fulfilled_order_item, order: order_2, item: item_2)

      expect(merchant_1.biggest_order).to eq(order_2)

      create(:fulfilled_order_item, quantity: 1000, order: order_1, item: item_1)
      expect(merchant_1.biggest_order).to eq(order_1)
    end
    it '.top_buyers(3)' do 
      user_1 = create(:user, city: 'Denver')
      user_2 = create(:user, city: 'Houston')
      user_3 = create(:user, city: 'Atlanta')
      merchant_1, merchant_2 = create_list(:merchant, 2)
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)

      # user 1 is in 2nd place
      order_1 = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, quantity: 100, price: 10, order: order_1, item: item_1)
      create(:fulfilled_order_item, quantity: 100, price: 10, order: order_1, item: item_2)
      # user 2 is 1st place
      order_2 = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, quantity: 1000, price: 10, order: order_2, item: item_1)
      create(:fulfilled_order_item, quantity: 1000, price: 10, order: order_2, item: item_2)
      # user 3 in last place
      order_3 = create(:completed_order, user: user_3)
      create(:fulfilled_order_item, quantity: 10, price: 10, order: order_3, item: item_1)
      create(:fulfilled_order_item, quantity: 10, price: 10, order: order_3, item: item_2)

      expect(merchant_1.top_buyers(3)).to eq([user_2, user_1, user_3])
    end
    it '.past_customer_emails' do 
      customer_100 = User.create(name: "Customer 100", address: 'gdfasdf', password: "password", email: "customer_100@customer.com", city: "Houston", state: "TX", zip: "00000", role: 0, active: true)
      customer_200 = User.create(name: "Customer 200", address: 'gdfasdf', password: "password", email: "customer_200@customer.com", city: "Denver", state: "CO", zip: "11111", role: 0, active: true)
      customer_300 = User.create(name: "Customer 300", address: 'gdfasdf', password: "password", email: "customer_300@customer.com", city: "Seattle", state: "WA", zip: "22222", role: 0, active: true)
      customer_400 = User.create(name: "Customer 400", address: 'gdfasdf', password: "password", email: "customer_400@customer.com", city: "Seattle", state: "WA", zip: "22222", role: 0, active: true)
      customer_500 = User.create(name: "Customer 500", address: 'gdfasdf', password: "password", email: "customer_500@customer.com", city: "Seattle", state: "WA", zip: "22222", role: 0, active: true)
     
      merchant_100 = User.create(name: "Merchant 100", address: 'gdfasdf', password: "password", email: "merchant_100@merchant.com", city: "Denver", state: "CO", zip: "33333", role: 1, active: true)
      item_100 = merchant_100.items.create(name: "Item 100", description: "This is a 100 item.", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Breathe-face-smile.svg/220px-Breathe-face-smile.svg.png", price: 500.55, inventory: 100)
      merchant_200 = User.create(name: "Merchant 200", address: 'gdfasdf', password: "password", email: "merchant_200@merchant.com", city: "Denver", state: "CO", zip: "33333", role: 1, active: true)
      item_200 = merchant_200.items.create(name: "Item 200", description: "This is a 200 item.", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Breathe-face-smile.svg/220px-Breathe-face-smile.svg.png", price: 600.66, inventory: 100)
      order_100 = customer_100.orders.create(status: "completed")
      order_200 = customer_200.orders.create(status: "completed")
      order_300 = customer_300.orders.create(status: "completed")
      order_400 = customer_400.orders.create(status: "pending")
      order_500 = customer_500.orders.create(status: "completed")
      order_item_100 = order_100.order_items.create(item_id: item_100.id, price: item_100.price, quantity: 1, fulfilled: true)
      order_item_200 = order_200.order_items.create(item_id: item_100.id, price: item_100.price, quantity: 1, fulfilled: true)
      order_item_300 = order_300.order_items.create(item_id: item_100.id, price: item_100.price, quantity: 1, fulfilled: true)
      order_item_400 = order_400.order_items.create(item_id: item_100.id, price: item_100.price, quantity: 1, fulfilled: false)
      order_item_500 = order_500.order_items.create(item_id: item_200.id, price: item_200.price, quantity: 1, fulfilled: true)
      # binding.pry

      expect(merchant_100.past_customer_emails).to include(customer_100.email)
      expect(merchant_100.past_customer_emails).to_not include(merchant_100.email)
      
      expect(merchant_100.past_customer_emails).to include(customer_300.email)
      
      
      expect(merchant_100.past_customer_emails).to include(customer_400.email)
      expect(merchant_100.past_customer_emails).to_not include(customer_500.email)

    end
    it '.not_customer_emails' do 
      customer_100 = User.create(name: "Customer 100", address: 'gdfasdf', password: "password", email: "customer_100@customer.com", city: "Houston", state: "TX", zip: "00000", role: 0, active: true)
      customer_200 = User.create(name: "Customer 200", address: 'gdfasdf', password: "password", email: "customer_200@customer.com", city: "Denver", state: "CO", zip: "11111", role: 0, active: true)
      customer_300 = User.create(name: "Customer 300", address: 'gdfasdf', password: "password", email: "customer_300@customer.com", city: "Seattle", state: "WA", zip: "22222", role: 0, active: true)
      customer_400 = User.create(name: "Customer 400", address: 'gdfasdf', password: "password", email: "customer_400@customer.com", city: "Seattle", state: "WA", zip: "22222", role: 0, active: true)
      customer_500 = User.create(name: "Customer 500", address: 'gdfasdf', password: "password", email: "customer_500@customer.com", city: "Seattle", state: "WA", zip: "22222", role: 0, active: true)
      customer_600 = User.create(name: "Customer 600", address: 'gdfasdf', password: "password", email: "customer_600@customer.com", city: "Seattle", state: "WA", zip: "22222", role: 0, active: true)
     
      merchant_100 = User.create(name: "Merchant 100", address: 'gdfasdf', password: "password", email: "merchant_100@merchant.com", city: "Denver", state: "CO", zip: "33333", role: 1, active: true)
      item_100 = merchant_100.items.create(name: "Item 100", description: "This is a 100 item.", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Breathe-face-smile.svg/220px-Breathe-face-smile.svg.png", price: 500.55, inventory: 100)
      merchant_200 = User.create(name: "Merchant 200", address: 'gdfasdf', password: "password", email: "merchant_200@merchant.com", city: "Denver", state: "CO", zip: "33333", role: 1, active: true)
      item_200 = merchant_200.items.create(name: "Item 200", description: "This is a 200 item.", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Breathe-face-smile.svg/220px-Breathe-face-smile.svg.png", price: 600.66, inventory: 100)
      order_100 = customer_100.orders.create(status: "completed")
      order_200 = customer_200.orders.create(status: "completed")
      order_300 = customer_300.orders.create(status: "completed")
      order_400 = customer_400.orders.create(status: "completed")
      order_500 = customer_500.orders.create(status: "completed")
      order_600 = customer_600.orders.create(status: "completed")
      order_item_100 = order_100.order_items.create(item_id: item_100.id, price: item_100.price, quantity: 1, fulfilled: true)
      order_item_200 = order_200.order_items.create(item_id: item_100.id, price: item_100.price, quantity: 1, fulfilled: true)
      order_item_300 = order_300.order_items.create(item_id: item_100.id, price: item_100.price, quantity: 1, fulfilled: true)
      order_item_400 = order_400.order_items.create(item_id: item_200.id, price: item_200.price, quantity: 1, fulfilled: true)
      order_item_500 = order_500.order_items.create(item_id: item_200.id, price: item_200.price, quantity: 1, fulfilled: true)
      order_item_600 = order_600.order_items.create(item_id: item_200.id, price: item_200.price, quantity: 1, fulfilled: true)
      order_item_650 = order_600.order_items.create(item_id: item_100.id, price: item_100.price, quantity: 1, fulfilled: true)
      
      expect(merchant_100.not_customer_emails(merchant_100.past_customer_emails)).to_not include(customer_100.email)
      expect(merchant_100.not_customer_emails(merchant_100.past_customer_emails)).to_not include(customer_200.email)
      expect(merchant_100.not_customer_emails(merchant_100.past_customer_emails)).to_not include(customer_300.email)
      
      expect(merchant_100.not_customer_emails(merchant_100.past_customer_emails)).to include(customer_400.email)
      expect(merchant_100.not_customer_emails(merchant_100.past_customer_emails)).to include(customer_500.email)
      expect(merchant_100.not_customer_emails(merchant_100.past_customer_emails)).to_not include(customer_600.email)
      expect(merchant_200.not_customer_emails(merchant_100.past_customer_emails)).to_not include(customer_600.email)
    end
  end
end
