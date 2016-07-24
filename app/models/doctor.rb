class Doctor < ActiveRecord::Base

  has_many :doctor_appointments
  has_many :appointments, through: :doctor_appointments

  has_many :doctor_specialties
  has_many :specialties, through: :doctor_specialties

  has_secure_password

end
