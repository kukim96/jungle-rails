require 'rails_helper'

RSpec.describe Product, type: :model do
    # validation tsets/examples here
    let(:category) {
      Category.create(name: "TestCategory")
    }
    subject {
      category.products.create(
        name: "TestProduct",
        price_cents: 777,
        quantity: 17,
      )
    }

    describe 'Validations' do
      it "is valid with valid attributes" do
        expect(subject).to be_valid
        expect(subject.errors.full_messages).to be_empty
      end

      it "is not valid without a name" do
        subject.name = nil
        expect(subject).to_not be_valid
        expect(subject.errors.full_messages.first).to include "Name can't be blank"
      end

      it "is not valid without a price" do
        subject.price_cents = nil
        expect(subject).to_not be_valid
        expect(subject.errors.full_messages).to include "Price can't be blank"
      end

      it "is not valid without a quantity" do
        subject.quantity = nil
        expect(subject).to_not be_valid
        expect(subject.errors.full_messages).to include "Quantity can't be blank"
      end

      it "is not valid without a category" do
        product = Product.create(
          name: "TestProduct",
          price_cents: 777,
          quantity: 17,
        )
        expect(product).to_not be_valid
        expect(product.errors.full_messages).to include "Category can't be blank"
      end
  end
end

