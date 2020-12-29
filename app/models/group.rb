class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :group_services
  has_many :services, through: :group_services
  has_many :passwords, through: :group_services

  def add_service_to_group(service_name, username, password)
    service = Service.find_or_create_by(name: service_name)
    new_service = GroupService.create(group_id: self.id, service_id: service.id, service_username: username)
    Password.create(group_service_id: new_service.id, password: password, current: true)
    puts "✅ Service added!"
  end

  def remove_service_from_group(service_name)
    service = Service.find_by(name: service_name)
    group_service = GroupService.find_by(group_id: self.id, service_id: service.id)
    group_service.destroy
    puts "💥 Service removed!"
  end

  def add_user_to_group(user)
    UserGroup.create(user_id: user.id, group_id: self.id)
    puts "🥳 Service removed!"
  end

  def remove_user_from_group(user)
    association = UserGroup.find_by(user_id: user.id, group_id: self.id)
    association.destroy
    puts "☠️ Service removed!"
  end

end
