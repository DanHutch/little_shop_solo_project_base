require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'Relationships' do
    it { should have_many(:orders) }
    it { should have_many(:items) }
  end

  describe 'Validations' do 
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end

  describe 'Class Methods' do 
  end

  describe 'Instance Methods' do 
    it '.subtotal' do
      order_item = create(:order_item)
      expect(order_item.subtotal).to eq(3)
    end
  end
end
