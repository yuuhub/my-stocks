class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :name, :string
    add_column :users, :balance, :decimal
    add_column :users, :status, :string
  end
end
