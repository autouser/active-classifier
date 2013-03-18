class CreateTelseyAttributes < ActiveRecord::Migration
  def change
    create_table :telsey_attributes do |t|
      t.integer :class_id
      t.string :mac
    end
  end
end
