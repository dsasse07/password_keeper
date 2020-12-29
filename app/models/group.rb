class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :group_services
  has_many :services, through: :group_services
  has_many :passwords, through: :group_services
end
