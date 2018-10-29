require 'rails_helper'

RSpec.describe 'Items Index' do
  context 'as a user' do 
    describe 'visiting /items' do 
      it 'should show all active items' do 
        active_item = create(:item)
        inactive_item = create(:inactive_item, name: 'inactive item 1')
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit items_path

        expect(page).to_not have_content(inactive_item.name)
        
        within "#item-#{active_item.id}" do 
          expect(page).to have_content("Merchant: #{active_item.user.name}")
          expect(page).to have_content(active_item.name)
          # code smell, had to hard-code an ID in the image filename for factorybot sequence
          expect(page.find("#item-image-#{active_item.id}")['src']).to have_content "image-1.jpg"
          expect(page).to have_content("Price: #{active_item.price}")
          expect(page).to have_content("Inventory: #{active_item.inventory}")

          click_link active_item.name
        end
        expect(current_path).to eq(item_path(active_item))
        visit items_path

        within "#item-#{active_item.id}" do 
          click_on "image for #{active_item.name}"
        end
        expect(current_path).to eq(item_path(active_item))
      end
    end
  end
end