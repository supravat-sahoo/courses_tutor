class Tutor < ApplicationRecord
  belongs_to :course

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, length: { maximum: 255 },
            uniqueness: { case_sensitive: false }
end
