class Patient < ActiveRecord::Base

  has_many :patient_appointments
  has_many :appointments, through: :patient_appointments
  
  has_secure_password

end
