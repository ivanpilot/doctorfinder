class Patient < ActiveRecord::Base

  extend Displayable::ClassMethods
  include Displayable::InstanceMethods

  has_many :doctor_patients
  has_many :doctors, through: :doctor_patients

  has_secure_password

  def book_appointment_with_doctor(appointment:, doctor_name:)
    doctor = Doctor.find_by(name: doctor_name)
    if !self.doctors.include?(doctor)
      self.doctors << doctor
    end

    doctor_patient = DoctorPatient.find_by(doctor_id: doctor.id, patient_id: self.id)
    doctor_patient.appointments << appointment
  end

end
