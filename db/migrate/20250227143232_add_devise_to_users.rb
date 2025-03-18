# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def self.up
    change_table :users do |t|
      ## Rename email_address to email
      t.rename :email_address, :email

      ## Change password_digest to encrypted_password
      t.rename :password_digest, :encrypted_password

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
    end

    # Reset index for email (was email_address before)
    remove_index :users, :email if index_exists?(:users, :email)
    add_index :users, :email, unique: true

    add_index :users, :reset_password_token, unique: true
  end

  def self.down
    change_table :users do |t|
      ## Rename email back to email_address
      t.rename :email, :email_address

      ## Change encrypted_password back to password_digest
      t.rename :encrypted_password, :password_digest

      ## Remove Recoverable
      t.remove :reset_password_token
      t.remove :reset_password_sent_at

      ## Remove Rememberable
      t.remove :remember_created_at
    end

    # Reset index
    remove_index :users, :email if index_exists?(:users, :email)
    add_index :users, :email_address, unique: true
  end
end
