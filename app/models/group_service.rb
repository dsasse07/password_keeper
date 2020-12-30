class GroupService < ActiveRecord::Base
  has_many :passwords
  belongs_to :service 
  belongs_to :group

  after_create do
    self.update(required_access: "any") if self.required_access.blank? 
  end

  def name_by_group_service_hash
    {self.service.name => self}
  end
  
end
