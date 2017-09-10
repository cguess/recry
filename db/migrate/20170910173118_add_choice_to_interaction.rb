class AddChoiceToInteraction < ActiveRecord::Migration[5.1]
  def change
  	add_column :interactions, :choice, :string
  end
end
