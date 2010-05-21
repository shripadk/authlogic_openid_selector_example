class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps
      t.string :login
      t.string :crypted_password
      t.string :password_salt
      t.string :email
      t.string :name
      t.string :openid_identifier, :null => true
      t.string :persistence_token, :null => true
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      t.boolean :email_autoset, :default => false, :null => false
    end
    
    add_index :users, :login
    add_index :users, :email
    add_index :users, :openid_identifier
    add_index :users, :persistence_token
    add_index :users, :last_request_at
  end

  def self.down
    drop_table :users
  end
end
