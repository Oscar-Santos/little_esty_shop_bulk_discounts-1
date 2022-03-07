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


      # def applied_discount
      #   applied_discount = 1
      #
      #   discounted_total = invoice_items.sum do |invoice_item|
      #       invoice_item.applied_discount
      #
      #     end
      #   end
      
    # total = 0
    # discounts = item.merchant.bulk_discounts.where('bulk_discounts.quantity <= ?', quantity)
    # if discounts.nil?
    #   unit_price * quantity
    # else
    #   x = discounts.max_by do |discount|
    #     discount.discount
    #   end
    #   ((1 - (x.discount / 100)) * (unit_price * quantity)).round(2)
    #
    #
    # end
    # item.merchant.bulk_discounts.max_by do |discount|
    #   applied_discount = 0
    #   if quantity >= discount.quantity
    #     applied_discount = discount.discount
    #   else
    #     applied_discount = 0
    #   end
    #   total = ((1 - applied_discount) * (unit_price * quantity)).round(2)
    # end
    # total

    def applied_discount
    price = item.unit_price
    item.merchant.bulk_discounts.order(discount: :desc, quantity: :desc).each do |discount|
      if quantity >= discount.quantity
        percent = discount.discount
        price = price - (percent * item.unit_price)
        break
      end
    end
    price
    end

    def self.discount_revenue
      all.map do |invoice_item|
        invoice_item.quantity * invoice_item.applied_discount
      end.sum

    end

    # def applied_discount
    #   applied_discount = 1
    #
    #   discounted_total = invoice_items.sum do |invoice_item|
    #       invoice_item.applied_discount
    #
    #     end
    #   end
    end
