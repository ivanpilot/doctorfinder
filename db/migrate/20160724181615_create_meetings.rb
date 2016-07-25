class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :appointment_id
      t.integer :doctor_patient_id
    end
  end
end
