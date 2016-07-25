class Doctor < ActiveRecord::Base

  has_many :doctor_patients
  has_many :patients, through: :doctor_patients

  has_many :doctor_specialties
  has_many :specialties, through: :doctor_specialties

  has_secure_password

  def slug
    self.name.split(" ").join("-")
  end

  def self.find_by_slug(slug)
    self.all.find {|patient| patient.slug == slug}
  end


end
