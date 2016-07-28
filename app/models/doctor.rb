class Doctor < ActiveRecord::Base

  has_many :doctor_patients
  has_many :patients, through: :doctor_patients

  has_many :doctor_specialties
  has_many :specialties, through: :doctor_specialties

  has_secure_password

  def slug
    self.name.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slug)
    self.all.find {|patient| patient.slug == slug.downcase}
  end

  def relationship_with_patient(patient)
    self.doctor_patients.find_by(patient_id: patient.id)
  end

  def meetings_all
    meetings = []
    self.doctor_patients.each do |doctor_patient|
      doctor_patient.meetings.each do |meeting|
        meetings << meeting
      end
    end
    meetings
  end

  def appointments_all
    appointments = []

    self.meetings_all.each do |meeting|
      appointment = {}
      appointment[:appointment] = meeting.appointment
      appointment[:patients] = meeting.appointment.find_participants[:patients].collect do |patient|
        patient
      end
      appointments << appointment
    end
    appointments#.sort_by{|appointment| appointment.start}
  end

  def meetings_with_patient(patient)
    relationship = self.relationship_with_patient(patient)
    self.meetings_all.select do |meeting|
      meeting.doctor_patient_id == relationship.id
    end
  end

  def appointments_with_patient(patient)
    self.meetings_with_patient(patient).collect do |meeting|
      meeting.appointment
    end
  end

  def slot_taken?(appointment)
    self.meetings_all.find do |meeting|
      meeting.appointment.start == appointment.start
    end
  end

  def book_appointment_with_patient(appointment, patient_name)
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


end
