class Location < ActiveRecord::Base
    has_many :users
    has_many :events
    
    validates :city, :state, presence: true
    validates :state, length: {is: 2}
end
