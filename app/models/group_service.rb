class GroupService < ActiveRecord::Base
  has_many :passwords
  belongs_to :service 
  belongs_to :group
end
