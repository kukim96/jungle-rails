require 'rails_helper'

RSpec.feature "Visitor clicks on 'Add' in order to add the product to the cart", type: :feature do
  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "'My Cart()' is updated to 'My Cart(1)'" do
    # ACT
    visit root_path

    expect(page).to have_content("My Cart (0)")

    within(".product:nth-of-type(1)") { click_button "Add" }

    expect(page).to_not have_content("My Cart (0)")
    expect(page).to have_content("My Cart (1)")
  end
end
