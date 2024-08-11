class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :company_name, type: String
  field :email, type: String

  has_many :customers
  has_many :transactions

end
