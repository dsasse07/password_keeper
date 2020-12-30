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
    puts "🥳 User Added!"
  end

  def remove_user_from_group(user)
    association = UserGroup.find_by(user_id: user.id, group_id: self.id)
    association.destroy
    puts "☠️ User Removed!"
  end

  def display_passwords_for_group
    services = self.services
    usernames = self.group_services.map(&:service_username)
    passwords = self.group_services.map do |group_service|
        Password.find_by(current: true, group_service_id: group_service.id)
    end

    puts "#{self.name.upcase} Login Credentials:"
    puts "\n"
    i = 0
    while i < services.length do 
      puts "#{services[i].name.upcase}"                 
      puts "--------------------"
      puts "Username: #{usernames[i]}"
      puts "Password: #{passwords[i].password}"
      puts "This password is #{passwords[i].calculate_age_in_days} days old."
      puts "\n"
      i += 1
    end
  end


  def create_service_menu_choices
    self.services.each_with_object({}) do |service, new_hash|
        new_hash[service.name] = service
    end
  end

end
