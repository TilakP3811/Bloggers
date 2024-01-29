class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable, :lockable

  has_one :incomplete_registration, class_name: 'Registration', dependent: :destroy

  def verify
    update verified: true
  end
end
