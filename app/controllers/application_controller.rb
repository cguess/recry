class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def send_sms phone_number, message
  	account_sid = ENV['TWILIO_ACCOUNT_SID'] # Your Account SID from www.twilio.com/console
		auth_token = ENV['TWILIO_ACCOUNT_AUTH_TOKEN']   # Your Auth Token from www.twilio.com/console

		@client = Twilio::REST::Client.new account_sid, auth_token
		message = @client.messages.create(
		    body: message,
		    to: phone_number,    # Replace with your phone number
		    from: ENV['TWILIO_PHONE_NUMBER'])  # Replace with your Twilio number
		
		logger.debug message.sid
		byebug
		return message.sid
  end

  def is_number? string
  	true if Float(string) rescue false
	end

end
