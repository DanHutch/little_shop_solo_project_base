require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

admin = create(:admin)
user = create(:user)
merchant_1 = create(:merchant)
user_1 = create(:user)
user_2 = create(:user)
user_3 = create(:user)
user_4 = create(:user)

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

item_1 = create(:item, user: merchant_1)
item_2 = create(:item, user: merchant_2)
item_3 = create(:item, user: merchant_3)
item_4 = create(:item, user: merchant_4)
create_list(:item, 10, user: merchant_1)

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

#my new seeds
order = create(:completed_order, user: user_1)
create(:fulfilled_order_item, order: order, item: item_1, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_1, price: 3, quantity: 1)

order = create(:completed_order, user: user_2)
create(:fulfilled_order_item, order: order, item: item_1, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_1, price: 3, quantity: 1)

order = create(:completed_order, user: user_3)
create(:fulfilled_order_item, order: order, item: item_1, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_1, price: 3, quantity: 1)

order = create(:completed_order, user: user_4)
create(:fulfilled_order_item, order: order, item: item_1, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_1, price: 3, quantity: 1)