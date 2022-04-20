class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :name
      t.decimal :price
      t.integer :quantity
      t.integer :user_id
      t.string :transaction_type

      t.timestamps
    end
  end
end
