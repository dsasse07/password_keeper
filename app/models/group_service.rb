class GroupService < ActiveRecord::Base
  has_many :passwords
  belongs_to :service 
  belongs_to :group

  after_create do
    self.update(required_access: "any") if self.required_access.blank? 
  end
end
