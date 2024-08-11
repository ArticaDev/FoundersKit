class InventoryItem
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :quantity, type: Integer
  field :min_quantity, type: Integer

  belongs_to :user
  has_many :inventory_categories
end
