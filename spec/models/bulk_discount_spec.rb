require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :discount }
    it { should validate_presence_of :quantity }
  
 end
  describe "relationships" do
    #it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :merchant }
  end
end
