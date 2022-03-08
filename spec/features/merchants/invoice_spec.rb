require 'rails_helper'

#USER STORY 7
RSpec.describe 'Merchant Invoice Show Page' do
  it 'displays total revenue from invoice ' do
    merchant = Merchant.create!(name: 'Hair Care')

    discount_1 = merchant.bulk_discounts.create!(discount: 0.20, quantity: 10)
    discount_2 = merchant.bulk_discounts.create!(discount: 0.30, quantity: 15)

    customer = Customer.create!(first_name: 'Victor', last_name: 'Garcia')
    item = merchant.items.create!(name: 'Toys', description: 'Kids', unit_price: 11.88)
    invoice = customer.invoices.create!(status: 0)
    invoice_item = InvoiceItem.create!(quantity: 23, unit_price: 11.88, status: 0, invoice_id: invoice.id, item_id: item.id)



    visit "/merchant/#{merchant.id}/invoices/#{invoice.id}"
    #require "pry"; binding.pry
    expect(page).to have_content('Total Revenue: $273.24')
    expect(page).to have_content('Total After Discount: $191.27')

  end

  #USER STORY 8
  it 'us 8' do
    merchant = Merchant.create!(name: 'Hair Care')

    discount_1 = merchant.bulk_discounts.create!(discount: 0.20, quantity: 10)
    discount_2 = merchant.bulk_discounts.create!(discount: 0.30, quantity: 15)

    customer = Customer.create!(first_name: 'Victor', last_name: 'Garcia')
    item = merchant.items.create!(name: 'Toys', description: 'Kids', unit_price: 17)
    invoice = customer.invoices.create!(status: 0)
    invoice_item = InvoiceItem.create!(quantity: 23, unit_price: 11.88, status: 0, invoice_id: invoice.id, item_id: item.id)


    visit "/merchant/#{merchant.id}/invoices/#{invoice.id}"

    expect(page).to have_link('View Discount', count: 1)
    click_on('View Discount')


    expect(current_path).to eq("/merchant/#{merchant.id}/bulk_discounts/#{discount_2.id}")

  end
end
