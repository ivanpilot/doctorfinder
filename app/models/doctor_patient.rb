class DoctorPatient < ActiveRecord::Base

  belongs_to :doctor
  belongs_to :patient

  has_many :meetings
  has_many :appointments, through: :meetings

end
