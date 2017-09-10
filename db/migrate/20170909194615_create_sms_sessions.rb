class CreateSmsSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sms_sessions do |t|
    	t.string :phone_number
    	t.boolean :completed, default: false
      t.timestamps
    end
  end
end
