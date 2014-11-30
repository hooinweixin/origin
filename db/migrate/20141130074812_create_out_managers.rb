class CreateOutManagers < ActiveRecord::Migration
  def change
    create_table :out_managers do |t|

      t.timestamps
    end
  end
end
