require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "class methods" do
    before(:each) do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end

    it 'subtotal revenue' do
      merchant = Merchant.create!(name: 'Hair Care')

      discount_1 = merchant.bulk_discounts.create!(discount: 0.20, quantity: 10)
      discount_2 = merchant.bulk_discounts.create!(discount: 0.30, quantity: 15)

      customer = Customer.create!(first_name: 'Victor', last_name: 'Garcia')
      item = merchant.items.create!(name: 'Toys', description: 'Kids', unit_price: 17)
      invoice = customer.invoices.create!(status: 0)
      invoice_item = InvoiceItem.create!(quantity: 23, unit_price: 11.88, status: 0, invoice_id: invoice.id, item_id: item.id)

      expect(invoice.total_revenue).to eq(273.24)
    end

    it 'discount revenue' do
      merchant = Merchant.create!(name: 'Hair Care')

      discount_1 = merchant.bulk_discounts.create!(discount: 0.20, quantity: 10)
      discount_2 = merchant.bulk_discounts.create!(discount: 0.30, quantity: 15)

      customer = Customer.create!(first_name: 'Victor', last_name: 'Garcia')
      item = merchant.items.create!(name: 'Toys', description: 'Kids', unit_price: 11.88)
      item_2 = merchant.items.create!(name: 'Towels', description: 'Adults', unit_price: 9.99)
      invoice = customer.invoices.create!(status: 0)
      invoice_item = InvoiceItem.create!(quantity: 23, unit_price: 11.88, status: 0, invoice_id: invoice.id, item_id: item.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 16, unit_price: 9.99, status: 0, invoice_id: invoice.id, item_id: item_2.id)

      expect(invoice.discount_revenue).to eq(303.156)
    end
  end
end
