class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :user_type, :null => false, :default => "patient"
    end
  end
end
