class VoiceController < ApplicationController
	skip_before_action :verify_authenticity_token

	def questions
		subjects = GoogleSheet.instance.subjects
	  # Start our TwiML response
	  message = nil

  	if params['Digits']
  		if(Integer(params['Digits']) > subjects.count || Integer(params['Digits']) < 1)
	 		  message = Twilio::TwiML::VoiceResponse.new do |r|
	 		  	r.say "I'm sorry that was not an allowed answer. Please try again.", voice: 'alice'
	 		  	r.redirect '/voice'
	 		  end.to_s
	 		else
		    subject = subjects[Integer(params['Digits']) - 1]
	 		  message = Twilio::TwiML::VoiceResponse.new do |r|
					r.say "The most up to date information with have about #{subject}, is the following", voice: 'alice'
					r.pause
					answers = GoogleSheet.instance.locations_for_subject(subject)
					answers.each do |answer|
						r.say answer.gsub(': ', ', at phone number, '), voice: 'alice'
						if(answers.last == answer)
							r.say "Thank you for calling, if you would like more information please call back again.", voice: 'alice'
						else
							r.pause
						end
					end
				end.to_s
			end
	  else
		  message = Twilio::TwiML::VoiceResponse.new do |r|
		    r.gather numDigits: 1 do |g|
			    # Use <Say> to give the caller some instructions
			    r.say('Thank you for calling the Rockport Fulton Chamber of Commerce Health Information Brochure. Please choose from one of the following options.', voice: 'alice')

					index = 1
					subjects.each do |subject|
						r.say "#{index}", voice: 'alice'
						r.say "#{subject}\n", voice: 'alice'
						index += 1
					end
				end
				r.redirect('/voice')
		  end.to_s
		end
	
		render inline: message
	end

end
