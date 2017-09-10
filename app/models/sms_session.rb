class SmsSession < ApplicationRecord

	def self.alive_sessions phone_number
		return SmsSession.where(completed: false).where('created_at > ?', 2.hours.ago)
	end
end
