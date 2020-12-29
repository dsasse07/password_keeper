class Service < ActiveRecord::Base
    has_many :passwords
    belongs_to :group
    has_many :user_groups, through: :group
end