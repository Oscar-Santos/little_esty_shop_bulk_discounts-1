class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end



    def applied_discount
    price = item.unit_price
    discount =  item.merchant.bulk_discounts.where("#{self.quantity} >= bulk_discounts.quantity").order(discount: :desc).first
    if discount.nil?
      quantity * unit_price
    else
      (1 - discount.discount) * (  quantity * unit_price)
    end

    end


    def view_discount
      item.merchant.bulk_discounts.where("#{self.quantity} >= bulk_discounts.quantity").order(discount: :desc).first
    end

  
    end
