class Store < ApplicationRecord
  has_many :market
  belongs_to :vendor
  has_many :products
  has_many :store_reviews

  validates :name, presence: true, length: {maximum: 50 }
  validates :vendor_id, presence: true
  validates :open_time, presence: true
  validates :close_time, presence: true
  validates :description,length: { maximum: 250 }

  validates :open_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 604800 }
  validates :close_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 604800 }
  validates :open_time, numericality: { less_than_or_equal_to: :close_time }
end
