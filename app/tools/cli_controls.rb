module CliControls

  @@prompt = TTY::Prompt.new
  @@heart = @@prompt.decorate(@@prompt.symbols[:heart] + " ", :magenta)

  # Overwriting the "yes?" method given by TTY prompt to have custom answers
  def yes_no(question_str)
      @@prompt.yes?(question_str) do |q|
      q.suffix "Yup!/Nope, I'm boring"
      q.positive "Yup!"
      q.negative "Nope, I'm boring"
      end
  end

  # A method for downcasing an ask
  def down_ask(str)
      @@prompt.ask(str).downcase
  end

end