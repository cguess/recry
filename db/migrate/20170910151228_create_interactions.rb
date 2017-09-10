class CreateInteractions < ActiveRecord::Migration[5.1]
  def change
    create_table :interactions do |t|
      t.timestamps
    end
  end
end
