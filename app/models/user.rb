class User < ActiveRecord::Base  
    has_many :user_groups
    has_many :groups, through: :user_groups
    has_many :group_services, through: :groups
    has_many :services, through: :group_services
    has_many :passwords, through: :group_services

    def change_app_password(new_password)
        self.update(app_password: new_password)
    end

    def change_app_username(new_username)
        self.update(app_username: new_username)
    end

    def delete_app_account
        self.destroy
    end

    def display_groups
        self.groups.reload.map(&:name)
    end

    def print_groups
        puts "CURRENT GROUPS"
        puts "---------------"
        self.display_groups.each do |group| 
            puts group.capitalize 
        end
        puts "---------------"
    end

    def create_group_menu_choices
        self.groups.reload.each_with_object({}) do |group, new_hash|
            new_hash[group.name.capitalize] = group
        end
    end

    def print_app_login_info
        puts "Current PasswordKeeper Credentials:"
        puts "\n"
        puts "Username: #{self.app_username}"
        puts "Password: #{self.app_password}"
        puts "Access Level: #{self.role}"
        puts "\n"
    end


end
