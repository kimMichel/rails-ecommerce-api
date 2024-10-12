class RemoveTotalFromOrderItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :order_items, :total, :decimal
  end
end
