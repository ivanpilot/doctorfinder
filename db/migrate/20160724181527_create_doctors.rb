class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :password_digest, :null => false
      t.string :user_type, :null => false, :default => "doctor"
    end
  end
end
