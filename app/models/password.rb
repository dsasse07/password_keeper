class Password < ActiveRecord::Base
  belongs_to :group_service

  include TwilioControls


    @@numbers = (0..9).to_a
    @@lower_case = ("a".."z").to_a
    @@upper_case = ("A".."Z").to_a
    @@symbols = ["@", "#", "!", "$"]
    CHARS = @@numbers + @@lower_case + @@upper_case + @@symbols

    def set_random_password(length = 15)
      secure_password = CHARS.sort_by { rand }.join[0..length]
      symbols_included = @@symbols.select {|symbol| secure_password.include?(symbol)}
      symbols_included.empty? ? set_random_password : secure_password
      self.update(password: secure_password)
    end

    def calculate_age_in_days
      (DateTime.now - (self.created_at).to_datetime).to_i
    end

    def share_password(user, to_phone_number)
      body = "#{user.display_full_name} has shared a password!\n\n
              Service Name: #{self.group_service.service.name}\n
              Username: #{self.group_service.service_username}\n
              Password: #{self.password}"
      send_sms(to: to_phone_number, body: body)
    end

  end

