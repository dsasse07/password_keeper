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
        self.groups.map(&:name)
    end

end
