class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  has_many :attendees
  has_many :comments
  has_many :users, through :attendees

  validates :name, :city, :state, presence: true
  validates :date, presence: true
end
