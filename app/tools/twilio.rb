# Download the twilio-ruby library from twilio.com/docs/libraries/ruby
require 'pry'
require 'dotenv/load'
require 'twilio-ruby'

module TwilioControls

  # To set up environmental variables, see http://twil.io/secure
  @@account_sid = ENV['TWILIO_ACCOUNT_SID']
  @@auth_token = ENV['TWILIO_AUTH_TOKEN']

  @@client = Twilio::REST::Client.new(@@account_sid, @@auth_token)

  @@from = '+12676338725' # Your Twilio number
  # to = '+16464790409' # Your mobile phone number

  def send_sms(to_phone_number, message)
    # message = {to:, from:, body: "Hello\n\nWorld"}
    # binding.pry
    @@client.messages.create(
    from: @@from,
    to: to_phone_number,
    body: message
    )
  end

end
