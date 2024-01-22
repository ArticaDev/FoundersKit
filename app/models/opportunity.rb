class Opportunity
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :notes, class_name: 'OpportunityNote'

  field :title, type: String
  field :price, type: Float
  field :notes, type: String
  field :stage, type: String, default: 'potential_customer'
  field :won, type: Mongoid::Boolean, default: false
  field :customer_email, type: String
  field :date, type: Date

  def customer
    Customer.find_by(email: customer_email)
  end

  def user
    customer.user
  end
end
