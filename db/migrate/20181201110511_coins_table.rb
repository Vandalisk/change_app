# Create coins table
#
class CoinsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :coins do |table|
      table.float :value
      table.integer :count
    end
  end
end
