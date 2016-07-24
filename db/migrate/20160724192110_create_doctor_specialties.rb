class CreateDoctorSpecialties < ActiveRecord::Migration
  def change
    create_table :doctor_specialties do |t|
      t.integer :doctor_id
      t.integer :specialty_id
    end
  end
end
