class PasswordKeeper
  include CliControls
  # here will be your CLI!
  # it is not an AR class so you need to add attr

  def run
    @user = ""
    welcome
    login_or_signup
    say_hi_to_user
    initial_menu


    # display_users_groups
    
  end

  private
  
  def welcome
    system 'clear'
    puts "Welcome to Password Keeper!"
    sleep(0.3)
  end

  def login_or_signup
    choices = ["New user", "Existing User", "Quit"]
    selection = @@prompt.select("Are you a", choices)
    case selection
    when "New user" 
      handle_new_user
    when "Existing User"
      handle_existing_user
    when "Quit"
      system 'clear'
    end
  end

  def say_hi_to_user
    puts "Welcome #{@user.first_name}"
  end

  def initial_menu
    choices = ["Access Passwords, Access User Settings, Access Group Settings, Logout"]
    selection = @@prompt.select("What would you like to do today?", choices)
    case selection
    when "Access Passwords user" 
      access_passwords
    when "Access User Settings"
      # user_settings
    when "Access Group Settings"
      # group_settings
    when "Logout"
      run
      system 'clear'
    end
  end

#################### Access Passwords ##################################



  ########### existing user ###########

  def handle_existing_user
    @user = gather_existing_data
  end

  def gather_existing_data
    while 0==0 
      system 'clear'
      @user = find_user
      return @user if !@user.nil?
      puts "User not found or password incorrect"
      return run if !yes_no("Would you like to try again?")
    end
  end

  def existing_user_input
    @@prompt.collect do
      key(:app_username).ask("Please enter your PasswordKeeper username: ", required: true) { |q| q.modify :down}
      key(:app_password).mask("Please enter your PasswordKeeper password: ", required: true, mask: @@heart)
    end
  end

  def find_user
    existing_user_info = existing_user_input
    @user = User.find_by(existing_user_info)
  end
  

  ########### new user ###########

  def handle_new_user
    @new_user_info = gather_new_user_data
    User.create(@new_user_info)
  end

  def gather_new_user_data
      system 'clear'
      @new_user_info = new_user_input
      @repeat_password = @@prompt.mask("Re-enter your PasswordKeeper to confirm: ", required: true, mask: @@heart)
      validate_new_user_credentials

  end

  def validate_new_user_credentials
    app_username_available? ? @new_user_info : name_taken
    passwords_match? ? @new_user_info : password_mismatch
  end

  def name_taken
    puts "⚠️  ⚠️  This username has already been taken. Please choose a new PasswordKeeper username ⚠️  ⚠️"
    @@prompt.keypress("Press space or enter to continue", keys: [:space, :return])
    gather_new_user_data
  end

  def app_username_available?
    username = @new_user_info[:app_username]
    User.find_by(app_username: username).nil?
  end

  def password_mismatch
    puts "⚠️  ⚠️  Passwords do not match. Please re-enter your information ⚠️  ⚠️"
    @@prompt.keypress("Press space or enter to continue", keys: [:space, :return])
    gather_new_user_data
  end

  def new_user_input
    @@prompt.collect do
      key(:first_name).ask("First Name? ", required: true) { |q| q.modify :down}
      key(:last_name).ask("Last Name? ", required: true) { |q| q.modify :down}
      key(:app_username).ask("Create your username for PasswordKeeper: ", required: true) { |q| q.modify :down}
      key(:app_password).mask("Create a password to access you PasswordKeeper account: ", required: true, mask: @@heart)
    end
  end

  def passwords_match?
    @new_user_info[:app_password] == @repeat_password
  end

  ######### user's group functions #########

  # def display_users_groups
  #   selection = @@prompt.select("Here are your groups, which one would you like to access? ", @user.display_groups)
  #   group = Group.find_by(name: selection)
  #   user_group = UserGroup.find_by(group_id: group.id, user_id: @user.id)
  #   user_group.services
  #   binding.pry
  #   # case selection
  # end

end