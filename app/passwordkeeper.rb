class PasswordKeeper
  include CliControls
  # here will be your CLI!
  # it is not an AR class so you need to add attr

  def run
    welcome
    login_or_signup
    display_users_groups
    # get_joke(what_subject)
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
    # @user = User.find_by(app_username: username)
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
    new_user_info = gather_new_user_data
    User.create(new_user_info)
  end

  def gather_new_user_data
    while 0==0 
      system 'clear'
      new_user_info = new_user_input
      repeat_password = @@prompt.mask("Re-enter your PasswordKeeper to confirm", required: true, mask: @@heart)
      return new_user_info if passwords_match?(new_user_info, repeat_password)
      puts "⚠️  ⚠️  Passwords do not match. Please re-enter your information ⚠️  ⚠️"
      @@prompt.keypress("Press space or enter to continue", keys: [:space, :return])
    end
  end

  def new_user_input
    @@prompt.collect do
      key(:first_name).ask("First Name? ", required: true) { |q| q.modify :down}
      key(:last_name).ask("Last Name? ", required: true) { |q| q.modify :down}
      key(:app_username).ask("Create your username for PasswordKeeper: ", required: true) { |q| q.modify :down}
      key(:app_password).mask("Create a password to access you PasswordKeeper account: ", required: true, mask: @@heart)
    end
  end

  def passwords_match?(new_user_info, repeat_password)
    new_user_info[:app_password] == repeat_password
  end

  ######### user's group functions #########

  def display_users_groups
    selection = @@prompt.select("Here are your groups, which one would you like to access? ", @user.display_groups)
    group = Group.find_by(name: selection)
    user_group = UserGroup.find_by(group_id: group.id, user_id: @user.id)
    user_group.services
    binding.pry
    # case selection
  end


#   choices = {"Scorpion" => 1, "Kano" => 2, "Jax" => 3}
# prompt.select("Choose your destiny?", choices)


end
