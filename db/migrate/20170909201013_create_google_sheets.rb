class CreateGoogleSheets < ActiveRecord::Migration[5.1]
  def change
    create_table :google_sheets do |t|

      t.timestamps
    end
  end
end
