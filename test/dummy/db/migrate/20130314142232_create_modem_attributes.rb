class CreateModemAttributes < ActiveRecord::Migration
  def change
    create_table :modem_attributes do |t|
      t.integer :class_id
      t.integer :num_of_ifs
      t.integer :line, :default => 1
    end
  end
end
