class Doctor < ActiveRecord::Base

  extend Displayable::ClassMethods
  include Displayable::InstanceMethods

  has_many :doctor_patients
  has_many :patients, through: :doctor_patients

  has_many :doctor_specialties
  has_many :specialties, through: :doctor_specialties

  has_secure_password

  ##############_______PUBLIC_______##############

  def slot_taken?(appointment)
    self.meetings_all.find do |meeting|
      appointment.start.between?(meeting.appointment.start, meeting.appointment.end) || appointment.end.between?(meeting.appointment.start, meeting.appointment.end)
    end
  end

  def slot_free?(appointment)
    !slot_taken?(appointment)
  end

  def slot_taken_to_update_appointment?(appointment_old:, appointment_new:)
    other_appointments = self.appointments_all.select do |other_appointment|
      other_appointment.id != appointment_old.id
    end

    other_appointments.find do |appt|
      appointment_new.start.between?(appt.start, appt.end) || appointment_new.end.between?(appt.start, appt.end)
    end
  end

  def book_appointment_with_patient(appointment:, patient_name:)
    patient = Patient.find_by(name: patient_name)
    if !patient
      patient = Patient.create(name: patient_name, password: patient_name)
    end

    if !self.patients.include?(patient)
      self.patients << patient
    end

    doctor_patient = DoctorPatient.find_by(doctor_id: self.id, patient_id: patient.id)
    doctor_patient.appointments << appointment
  end

  def self.find_by_specialty_id(specialty_id:)
    Doctor.all.select do |doctor|
      doctor.specialty_ids.include?(specialty_id.to_i)
    end
  end

  def self.find_by_id_or_specialty_id(id: nil, specialty_id: nil)
    id == nil ? self.find_by_specialty_id(specialty_id: specialty_id) : self.find_by(id: id)
  end

end
