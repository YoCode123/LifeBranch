class RenameFirstLoginToFirstLoginDoneInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :first_login, :first_login_done
  end
end
