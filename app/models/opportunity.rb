class Opportunity
  include Mongoid::Document
  include Mongoid::Timestamps
  field :price, type: Float
  field :notes, type: String
  field :stage, type: String, default: 'potential_customer'
  field :won, type: Mongoid::Boolean, default: false
  field :customer_email, type: String

  def customer
    Customer.find_by(email: customer_email)
  end
end
