class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string      :email,     null: true
      t.string      :name,      null: true
      t.string      :avatar,    null: true
      t.boolean     :admin,     null: false, default: false
      t.timestamps              null: false
    end
  end
end
