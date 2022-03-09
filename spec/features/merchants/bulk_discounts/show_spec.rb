require 'rails_helper'

RSpec.describe 'Bulk discounts Show Page' do

  #USER STORY 5

  it 'displays discounts quantity threshold and percentage discount ' do
    merchant = Merchant.create!(name: 'Hair Care')

    discount_1 = merchant.bulk_discounts.create!(discount: 0.20, quantity: 10)
    discount_2 = merchant.bulk_discounts.create!(discount: 0.30, quantity: 15)

    visit "/merchant/#{merchant.id}/bulk_discounts/#{discount_1.id}"
    expect(page).to have_content(discount_1.discount)
    expect(page).to have_content(discount_1.quantity)
    
  end

#USER STORY 6

it 'displays the discounts current attributes' do
    merchant = Merchant.create!(name: 'Hair Care')

    discount_1 = merchant.bulk_discounts.create!(discount: 0.20, quantity: 10)
    discount_2 = merchant.bulk_discounts.create!(discount: 0.30, quantity: 15)

    visit "/merchant/#{merchant.id}/bulk_discounts/#{discount_1.id}"

    expect(page).to have_link('Edit Discount')
    click_link('Edit Discount')
    expect(current_path).to eq("/merchant/#{merchant.id}/bulk_discounts/#{discount_1.id}/edit")

    fill_in('Discount', with: '0.15')
    fill_in('Quantity', with: '5')
    click_on('Edit Discount')

    expect(current_path).to eq("/merchant/#{merchant.id}/bulk_discounts/#{discount_1.id}")

    expect(page).to have_content('Percentage Discount: 0.15')
    expect(page).to have_content('Quantity Threshold: 5')
    expect(page).to_not have_content('Percentage Discount: 0.20')
    expect(page).to_not have_content('Quantity threshold: 10')
  end
end
