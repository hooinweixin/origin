class CreateTruckInfos < ActiveRecord::Migration
  def change
    create_table :truck_infos do |t|

      t.timestamps
    end
  end
end
