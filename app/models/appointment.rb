class Appointment < ActiveRecord::Base

  has_many :doctor_appointments
  has_many :doctors, through: :doctor_appointments

  has_many :patient_appointments
  has_many :patients, through: :patient_appointments

end
