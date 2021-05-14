class Course < ApplicationRecord
    has_many :subscriptions
    has_many :users, through: :subscriptions
end
