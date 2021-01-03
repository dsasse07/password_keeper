class Password < ActiveRecord::Base
    belongs_to :group_service




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

  end