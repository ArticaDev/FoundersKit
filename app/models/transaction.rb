class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :type, type: String
  field :amount, type: Float
  field :date, type: Date
  field :recurrency, type: String

  belongs_to :user

end
