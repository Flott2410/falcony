require 'twilio-ruby'

class TwilioClient
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

  def send_text(user, message)
    client.api.account.messages.create(
      to: user.phone_number,
      from: '+447445101924',
      body: message
    )
  end

  def new_daily_cases_notification(user, message)
    client.api.account.messages.create(
      to: user.phone_number,
      from: '+447445101924',
      body: message
    )
  end

  private

  def account_sid
    # Rails.application.credentials.twilio[:account_sid]
    account_sid = ENV["TWILIO_ACCOUNT_SID"]
  end

  def auth_token
    # Rails.application.credentials.twilio[:auth_token]
    ENV["TWILIO_AUTH_TOKEN"]
  end
end
