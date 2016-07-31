module Displayable

  module InstanceMethods

    def slug
      self.name.downcase.split(" ").join("-")
    end

    def relationship_with(user)
      user_type = user.class == Doctor ? "patient" : "doctor"
      hash = {(user_type + "_id").to_sym => user.id}
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

  end

  ###########################################################################

  module ClassMethods

    def find_by_slug(slug)
      self.all.find {|user| user.slug == slug.downcase}
    end





  end

end
