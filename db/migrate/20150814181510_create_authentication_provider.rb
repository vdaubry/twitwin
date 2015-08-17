class CreateAuthenticationProvider < ActiveRecord::Migration
  def change
    create_table :authentication_providers do |t|
      t.integer     :user_id,    null: false
      t.string      :provider,   null: false
      t.string      :uid,        null: false
      t.string      :token,      null: false
      t.string      :secret,     null: true
      t.timestamps               null: false
    end
    
    add_index :authentication_providers, :user_id
    add_index :authentication_providers, :uid, unique: true
  end
end
