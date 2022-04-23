class AddTickerToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :ticker, :string
  end
end
