class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :name
      t.decimal :last_price
      t.integer :quantity
      t.integer :user_id
      t.string :ticker

      t.timestamps
    end
  end
end
