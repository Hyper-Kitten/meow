require 'rails_helper'

module HyperKittenMeow
  RSpec.describe Menu, type: :model do
    describe "#menu_items" do
      it "orders by position" do
        menu = create(:menu)
        menu_item_2 = create(:menu_item, menu: menu, position: 1)
        menu_item_1 = create(:menu_item, menu: menu, position: 2)
        menu_item_3 = create(:menu_item, menu: menu, position: 3)

        expect(menu.menu_items.pluck(:id)).
          to eq([menu_item_2.id, menu_item_1.id, menu_item_3.id])

        menu_item_1.update(position: 1)
        menu_item_2.update(position: 2)

        expect(menu.menu_items.pluck(:id)).
          to eq([menu_item_1.id, menu_item_2.id, menu_item_3.id])
      end
    end
  end
end
