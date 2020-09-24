class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :send_welcome_email

  belongs_to :country
  has_many :trips, dependent: :destroy
  has_one_attached :photo

  validates :photo, presence: false
  validates :phone_number, phone: true

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end

end
