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
    # binding.pry
    puts "Welcome #{@user.first_name}"
  end

  def initial_menu
    choices = ["Access Passwords", "Access User Settings", "Access Group Settings", "Logout"]
    selection = @@prompt.select("What would you like to do today?", choices)
    case selection
    when "Access Passwords" 
      access_passwords
    when "Access User Settings"
      user_settings
    when "Access Group Settings"
      # group_settings
    when "Logout"
      run
      system 'clear'
    end
  end

######################## User Settings ############################
def user_settings
  system 'clear'
  print_user_info
  user_settings_action_selection
end

def print_user_info
  @user.print_app_login_info
end

def user_settings_action_selection
  choices = ["Change PasswordKeeper Username", "Change PasswordKeeper Password", "Back", "Logout"]
  selection = @@prompt.select("What would you like to do?", choices)
  case selection
  when "Change PasswordKeeper Username"
    change_app_username_handler
  when "Change PasswordKeeper Password"
    change_app_password_handler
  when "Back"
    initial_menu
  when "Logout"
    run
    system 'clear'
  end
end

def change_app_username_handler
  @new_app_username = @@prompt.ask("Please enter your new PasswordKeeper username: ", required: true)
  validate_new_username
  @user.update(app_username: @new_app_username)
  puts "✅ Your PasswordKeeper username has been updated to #{@user.app_username}."
  @@prompt.keypress("Press space or enter to return to User Settings Menu", keys: [:space, :return])
  user_settings
end

def validate_new_username
  if !app_username_available?(@new_app_username)
    name_taken
    change_app_username_handler
  end
end

def change_app_password_handler
  @new_app_password = @@prompt.mask("Please enter your new PasswordKeeper password: ", required: true, mask: @@heart)
  @repeat_password = @@prompt.mask("Re-enter your PasswordKeeper to confirm: ", required: true, mask: @@heart)
  validate_new_password
  @user.update(app_password: @new_app_password)
  puts "✅ Your PasswordKeeper password has been updated to #{@user.app_password}."
  @@prompt.keypress("Press space or enter to return to User Settings Menu", keys: [:space, :return])
  user_settings
end

def validate_new_password
  if !passwords_match?(@new_app_password)
    password_mismatch
    change_app_password_handler
  end
end


#################### Access Passwords ##################################

def access_passwords
  system 'clear'
  print_all_passwords
  password_action_selection
end

def password_action_selection
  choices = ["Change Password", "Back", "Logout"]
  selection = @@prompt.select("What would you like to do?", choices)
  case selection
  when "Change Password"
    change_password_handler
  when "Back"
    initial_menu
  when "Logout"
    run
    system 'clear'
  end
end

def change_password_handler
  @group = select_group
  @service = select_service
  update_password  
  #Generate random & update
  #update password
end

def update_password
  group_service = GroupService.find_by(group_id: @group.id, service_id: @service.id)
  group_service.current_password.update(current: false)
  new_password = Password.new(group_service_id: group_service.id)
  if secure_password?
    new_password.set_random_password
  else
    new_password.update(password: enter_custom_password)
  end
  puts " ✅ Your password for #{@service.name} has been changed to:  #{new_password.password}."
end
  
def enter_custom_password
  @@prompt.ask("What password would you like to use for #{@service.name}?")
end

def secure_password?
  yes_no("🔒 🔒 Would you like to generate a SUPER-DUPER secure password 🔒 🔒")
end

def select_group
  choices = @user.create_group_menu_choices
  group_selection = @@prompt.select("Which group's service would you like change?", choices)
end

def select_service
  choices = @group.create_service_menu_choices
  selection = @@prompt.select("Which service's password would you like change?", choices)
end

def print_all_passwords
  @user.groups.each {|group| group.display_passwords_for_group}
end

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
  end

  def gather_new_user_data
      system 'clear'
      @new_user_info = new_user_input
      @repeat_password = @@prompt.mask("Re-enter your PasswordKeeper to confirm: ", required: true, mask: @@heart)
      gather_new_user_data if !(validate_new_user_credentials == @new_user_info)
      @user = User.create(@new_user_info)
  end

  def validate_new_user_credentials
    if app_username_available?(@new_user_info[:app_username])
      return @new_user_info
    else 
      name_taken
      return false
    end
    if passwords_match?(@new_user_info[:app_password])
      return @new_user_info
    else 
      password_mismatch
      return false
    end
  end

  def name_taken
    puts "⚠️  ⚠️  This username has already been taken. Please choose a new PasswordKeeper username ⚠️  ⚠️"
    @@prompt.keypress("Press space or enter to continue", keys: [:space, :return])
  end

  def app_username_available?(username)
    User.find_by(app_username: username).nil?
  end

  def password_mismatch
    puts "⚠️  ⚠️  Passwords do not match. Please re-enter your information ⚠️  ⚠️"
    @@prompt.keypress("Press space or enter to continue", keys: [:space, :return])
  end

  def new_user_input
    @@prompt.collect do
      key(:first_name).ask("First Name? ", required: true) { |q| q.modify :down}
      key(:last_name).ask("Last Name? ", required: true) { |q| q.modify :down}
      key(:app_username).ask("Create your username for PasswordKeeper: ", required: true) { |q| q.modify :down}
      key(:app_password).mask("Create a password to access you PasswordKeeper account: ", required: true, mask: @@heart)
    end
  end

  def passwords_match?(password)
    password == @repeat_password
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
