class SmsController < ApplicationController

	def questions
		# # check if number has sms_session still in action
		# session = SmsSession.alive_sessions params[:From]
		# # if no, then pull questions (probably cached) from Google Sheet
		# if(session.count < 1)			
			subjects = GoogleSheet.instance.subjects
		# end	

		message_text = ""
	  response = Twilio::TwiML::MessagingResponse.new

		if is_number?(params[:Body])
			begin
				option_number = Integer(params[:Body])
			rescue 
				option_number = Float(params[:Body])
				option_number = Integer(option_number.floor)
			end

			if option_number > subjects.count || option_number < 1	
				message_text = "Please choose an subject for information between 1 and #{subjects.count}\n----\n" + message_for_subjects(subjects)
			else
				subject = subjects[option_number - 1]
				message_text = subject + "\n----\n" + GoogleSheet.instance.locations_for_subject(subject).join("\n\n")
			end
		else
			acceptable_response = false
			subject_index = -1
			index = 0
			subjects.each do |subject|

				if subject.downcase == params[:Body].downcase
					acceptable_response = true
					subject_index = index
					break
				end
				index += 1
			end

			if(acceptable_response == true)
				subject = subjects[subject_index]
				message_text = subject + "\n----\n" + GoogleSheet.instance.locations_for_subject(subject).join("\n\n")
			else
				message_text = "Please reply with the number of the option below for information on services available.\n----\n" + message_for_subjects(subjects)
			end
		end

		response.message do |message|
		  message.body(message_text)
		  #message.to(params[:From])
		end

		render inline: response.to_s
	end

	def message_for_subjects subjects
		message_text = ""
		index = 1
		subjects.each do |subject|
			message_text += "#{index}) #{subject}\n"
			index += 1
		end
		return message_text
	end

end
