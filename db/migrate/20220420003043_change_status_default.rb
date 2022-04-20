class ChangeStatusDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :status, "disapproved"
    change_column_default :users, :balance, default: 0.0
    change_column_default :users, :admin, default: false
  end
end
