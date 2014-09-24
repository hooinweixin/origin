class CreateTruckusers < ActiveRecord::Migration
  def change
    create_table :truckusers do |t|

      t.timestamps
    end
  end
end
