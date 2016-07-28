class Appointment < ActiveRecord::Base

  has_many :meetings
  has_many :doctor_patients, through: :meetings

  ##############_______PUBLIC_______##############

  def details
    appointment_details = {
      :doctors => [],
      :patients => []
    }

    appointment_details[:start] = self.start
    appointment_details[:end] = self.end

    self.doctor_patients.each do |doctor_patient|
      appointment_details[:doctors] << Doctor.find(doctor_patient.doctor_id)
      appointment_details[:patients] << Patient.find(doctor_patient.patient_id)
    end
    appointment_details
  end

end
