class Appointment < ActiveRecord::Base

  has_many :meetings
  has_many :doctor_patients, through: :meetings

  ##############_______PUBLIC_______##############

  def self.instantiate_appointment(params)
    # hash = Hash[hash.collect{|k,v| [k.to_sym, v.to_i]}]
    year = params["year"].to_i
    month = params["month"].to_i
    day = params["day"].to_i
    hour = params["hour"].to_i
    minute = params["minute"].to_i
    hour_end = minute == 0 ? hour : hour + 1

    Appointment.new(start: DateTime.new(year, month, day, hour, minute), end: DateTime.new(year, month, day, hour_end, minute - 1))
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

  def cancel_appointment
    meeting = Meeting.find_by(appointment_id: self.id)
    meeting.delete
    self.delete
  end

end
