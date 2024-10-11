class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :name
      t.string :description
      t.decimal :price

      t.timestamps
    end
  end
end
