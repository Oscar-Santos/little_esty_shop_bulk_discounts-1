class Invoice < ApplicationRecord
  validates_presence_of :status,
  :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', 'complete']

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discount_revenue
    invoice_items.sum do |invoice_item|
      invoice_item.applied_discount
    end
    
  end

end
