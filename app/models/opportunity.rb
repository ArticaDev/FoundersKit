class Opportunity
  include Mongoid::Document
  include Mongoid::Timestamps
  field :price, type: Decimal
  field :notes, type: String
  field :stage, type: String
  field :won, type: Mongoid::Boolean
  belongs_to :customer
end
