class User < ActiveRecord::Base  
    has_many :user_groups
    has_many :groups, through: :user_groups
    has_many :group_services, through: :groups
    has_many :services, through: :group_services
    has_many :passwords, through: :group_services
end
