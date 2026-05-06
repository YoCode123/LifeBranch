class ChangeFirstLoginDoneDefault < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :first_login_done, from: true, to: false
  end
end
