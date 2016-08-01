module Displayable

  module InstanceMethods

    def slug
      self.name.downcase.split(" ").join("-")
    end

    def relationship_with(user)
      hash = {(user.class.to_s.downcase + "_id").to_sym => user.id}
      self.doctor_patients.find_by(hash)
    end

    def meetings_with(user)
      relationship = self.relationship_with(user)
      self.meetings_all.select do |meeting|
        meeting.doctor_patient_id == relationship.id
      end
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
      appointments = self.meetings_all.collect do |meeting|
        meeting.appointment
      end
      appointments.sort_by {|appointment| appointment.details[:start]}
    end

    def appointments_history
      self.appointments_all.select do |appointment|
        appointment.details[:end] < DateTime.now
      end.reverse
    end

    def appointments_coming
      self.appointments_all.select do |appointment|
        appointment.details[:end] > DateTime.now
      end
    end

    def appointments_with(user)
      appointments = self.meetings_with(user).collect do |meeting|
        meeting.appointment
      end
      appointments.sort_by {|appointment| appointment.details[:start]}
    end

    def slot_taken?(appointment)
      self.meetings_all.find do |meeting|
        appointment.start.between?(meeting.appointment.start, meeting.appointment.end)
      end
    end

  end

  ###########################################################################

  module ClassMethods

    def find_by_slug(slug)
      self.all.find {|user| user.slug == slug.downcase}
    end

  end

end
