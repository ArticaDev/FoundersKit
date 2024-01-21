class Customer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :phone, type: String
  field :email, type: String

  belongs_to :user

  def opportunities
    Opportunity.where(customer_email: email)
  end
end
