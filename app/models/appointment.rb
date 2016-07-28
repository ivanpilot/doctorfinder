class Appointment < ActiveRecord::Base

  has_many :meetings
  has_many :doctor_patients, through: :meetings

  def find_participants
    appointment_info = {
      :doctors => [],
      :patients => []
    }
    # appointment_info[:start] = 
    self.doctor_patients.each do |doctor_patient|
      appointment_info[:doctors] << Doctor.find(doctor_patient.doctor_id)
      appointment_info[:patients] << Patient.find(doctor_patient.patient_id)
    end
    appointment_info
  end

  # def sorted()


end
