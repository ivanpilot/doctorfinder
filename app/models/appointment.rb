class Appointment < ActiveRecord::Base

  has_many :meetings
  has_many :doctor_patients, through: :meetings

  def find_participants
    participants = {
      :doctors => [],
      :patients => []
    }

    self.doctor_patients.each do |doctor_patient|
      participants[:doctors] << Doctor.find(doctor_patient.doctor_id)
      participants[:patients] << Patient.find(doctor_patient.patient_id)
    end
    participants
  end
end
