class PasswordKeeper
  include CliControls
  # here will be your CLI!
  # it is not an AR class so you need to add attr

  def run
    welcome
    login_or_signup
    # wanna_see_favs?
    # get_joke(what_subject)
  end

  private
  
  def welcome
    system 'clear'
    puts "Welcome to Password Keeper!"
    sleep(0.3)
  end

  def login_or_signup
    choices = ["New user", "Existing User"]
    selection = @@prompt.select("Are you a", choices)
    if selection == "New user"
      handle_new_user
    end
    
    # @user = User.find_by(app_username: username)
  end

  def handle_new_user
    new_user_info = gather_new_user_data
    binding.pry
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


end
