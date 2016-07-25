class Doctor < ActiveRecord::Base

  has_many :doctor_patients
  has_many :patients, through: :doctor_patients

  has_many :doctor_specialties
  has_many :specialties, through: :doctor_specialties

  has_secure_password

end
