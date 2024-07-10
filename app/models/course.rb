class Course < ApplicationRecord
  has_many :tutors, dependent: :destroy
  accepts_nested_attributes_for :tutors

  validates :title, length: { in: 3..50 }
end
