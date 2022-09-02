class AddAuthenticationTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column(:users, :authentication_token, :string, null: false)
    add_index(:users, :authentication_token, unique: true)
  end
end
