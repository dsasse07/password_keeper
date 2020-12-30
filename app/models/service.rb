class Service < ActiveRecord::Base
    has_many :group_services
    has_many :groups, through: :group_services
    has_many :passwords, through: :group_services
    has_many :user_groups, through: :groups

end