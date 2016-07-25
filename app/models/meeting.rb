class Meeting < ActiveRecord::Base

  belongs_to :appointment
  belongs_to :doctor_patient

end
