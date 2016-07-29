class Appointment < ActiveRecord::Base

  has_many :meetings
  has_many :doctor_patients, through: :meetings

  ##############_______PUBLIC_______##############

  def self.instantiate_appointment(year:, month:, day:, hour:, minute:)
    year_i = year.to_i
    month_i = month.to_i
    day_i = day.to_i
    hour_i = hour.to_i
    minute_i = minute.to_i
    Appointment.new(start: DateTime.new(year_i, month_i, day_i, hour_i, minute_i), end: DateTime.new(year_i, month_i, day_i, hour_i + 1, minute_i))
  end

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
