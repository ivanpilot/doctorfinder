class DoctorsController < ApplicationController

  get "/doctors/:slug/home" do
    if is_logged_in? && user_type? == "doctor"
      @doctor = Doctor.find(session[:id])
      erb :'doctors/home'
    else
      redirect to "/"
    end
  end

  get "/doctors/:slug/profile" do
    if is_logged_in? && user_type? == "doctor"
      erb :'doctors/profile_show'
    else
      redirect to "/"
    end
  end

  get "/doctors/:slug/profile/edit" do
    if is_logged_in? && user_type? == "doctor"
      erb :'doctors/profile_edit'
    else
      redirect to "/"
    end
  end

  patch "/doctors/:slug/profile/edit" do
    doctor = Doctor.find_by_slug(params[:slug])
    doctor.update(params[:doctor])
    doctor.save
    redirect to "/doctors/#{doctor.slug}/profile"
  end

  get "/doctors/:slug/appointment_new" do
    if is_logged_in? && user_type? == "doctor"
      erb :'doctors/appointment_new'
    else
      redirect to "/"
    end
  end

  post "/doctors/:slug/appointment_new" do

    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i
    hour = params[:hour].to_i
    minute = params[:minute].to_i

    appointment = Appointment.new(start: DateTime.new(year, month, day, hour, minute), end: DateTime.new(year, month, day, hour + 1, minute))

    appointment_booked = Appointment.all.find {|appointment|  appointment.doctor_patients.doctor_id == current_doctor_user.id}
    if appointment_booked.include?(appointment)
      redirect to "/doctors/:slug/appointment_new"
    else
      appointment.save
    end

    # current_doctor_user.doctor_patients.all.each do |doctor_patient|
    #   if doctor_patient.appointments.include?(appointment)
    #     redirect to "/doctors/:slug/appointment_new"
    #   else
    #     appointment.save
    #   end
    # end

    patient_found = Patient.find_by(name: params[:patient_name])
    if !patient_found
      patient_new = Patient.create(name: params[:patient_name], password: params[:patient_name])
      current_doctor_user.patients << patient_new
      doctor_patient = DoctorPatient.find_by(doctor_id: current_doctor_user.id, patient_id: patient_new.id)
    elsif patient_found && current_doctor_user.patients.include?(patient_found)
      doctor_patient = DoctorPatient.find_by(doctor_id: current_doctor_user.id, patient_id: patient_found.id)
    else patient_found
      current_doctor_user.patients << patient_found
      doctor_patient = DoctorPatient.find_by(doctor_id: current_doctor_user.id, patient_id: patient_found.id)
    end
    doctor_patient.appointments << appointment




    # # binding.pry
    # if !current_doctor_user.patients.include?(@patient)
    #   current_doctor_user.patients << @patient
    # end
    # @doctor_patient =

    redirect to "/doctors/:slug/home"
  end



end
