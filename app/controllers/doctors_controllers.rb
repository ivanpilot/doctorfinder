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
    month = params[:year].to_i
    day = params[:year].to_i
    hour = params[:year].to_i
    minute = params[:year].to_i

    start_time = DateTime.new(year, month, day, hour, minute)
    end_time = DateTime.new(year, month, day, hour + 1, minute)
    @appointment = Appointment.create(start: start_time, end: end_time)

    @patient = Patient.find_or_create_by(name: params[:patient_name])
    if !current_doctor_user.patients.include?(@patient)
      current_doctor_user.patients << @patient
    end
    @doctor_patient = DoctorPatient.find_by(doctor_id: current_doctor_user.id, patient_id: @patient.id)
    @doctor_patient.appointments.all << @appointment

    redirect to "/doctors/:slug/home"
  end



end
