class User < ActiveRecord::Base
  belongs_to :location
  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :attendees
  has_many :attending_events, through: :attendees, source: :events
  has_secure_password

  before_validation :email_lowercase
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  validates :first_name, :last_name, presence: true, length: {minimum: 2}
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: EMAIL_REGEX}
  validates :password, presence: true, length: {minimum: 8}

  private
    def email_lowercase
      self.email.downcase!
    end
end
