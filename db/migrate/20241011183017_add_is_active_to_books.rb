class AddIsActiveToBooks < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :is_active, :boolean, default: true
  end
end
