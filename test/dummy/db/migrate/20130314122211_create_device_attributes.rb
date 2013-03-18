class CreateDeviceAttributes < ActiveRecord::Migration
  def change
    create_table :device_attributes do |t|
      t.integer :class_id
      t.string :vendor
      t.datetime :issued_at
    end
  end
end
