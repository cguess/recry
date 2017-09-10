require 'singleton'

class GoogleSheet < ApplicationRecord
	include Singleton
	
	def initialize
		# Authenticate a session with your Service Account
    @session = GoogleDrive::Session.from_service_account_key("client_secret.json")
  end

	def subjects 
		# Get the spreadsheet by its title
		spreadsheet = @session.spreadsheet_by_title(ENV['GOOGLE_SHEET_NAME'])
		# Get the first worksheet
		worksheet = spreadsheet.worksheets.first
		return worksheet.rows.first
	end

	def locations_for_subject subject_to_search
		# Get the spreadsheet by its title
		spreadsheet = @session.spreadsheet_by_title(ENV['GOOGLE_SHEET_NAME'])
		# Find the correct column to look for
		worksheet = spreadsheet.worksheets.first

		row_index = 0
		subjects = worksheet.rows.first
		subjects.each do |subject|
			row_index += 1
			break if subject_to_search == subject
			row_index = -1 if subject == subjects.last
		end

		return nil if row_index == -1

		locations = (2..worksheet.num_rows).map {|row| worksheet[row, row_index]}
		return locations
	end


end
