class PatientsController < ApplicationController

  get "/patients/:slug/home" do
    if is_logged_in? && user_type? == "patient"
      @patient = Patient.find(session[:id])
      erb :'patients/home'
    else
      redirect to "/"
    end
  end

  get "/patients/:slug/profile" do
    if is_logged_in? && user_type? == "patient"
      erb :'patients/profile_show'
    else
      redirect to "/"
    end
  end

  get "/patients/:slug/profile/edit" do
    if is_logged_in? && user_type? == "patient"
      erb :'patients/profile_edit'
    else
      redirect to "/"
    end
  end

  patch "/patients/:slug/profile/edit" do
    patient = Patient.find_by_slug(params[:slug])
    patient.update(params[:patient])
    patient.save
    flash[:notice] = "Your profile has been updated."
    redirect to "/patients/#{patient.slug}/profile"
  end

  get "/patients/:slug/appointment_new" do
    if is_logged_in? && user_type? == "patient"
      erb :'patients/appointment_new'
    else
      redirect to "/"
    end
  end

  post "/patients/:slug/appointment_new" do
    appointment = Appointment.instantiate_appointment(params[:appointment_date])

    if current_doctor_user.slot_taken?(appointment) || params[:patient_name].empty?
      flash[:notice] = "This slot is already taken. Please choose another slot."
      redirect to "/doctors/#{current_doctor_user.slug}/appointment_new"
    else
      appointment.save
      current_doctor_user.book_appointment_with_patient(appointment, params[:patient_name])
    end
    flash[:notice] = "Your appointment with #{params[:patient_name]} is booked."
    redirect to "/patients/#{current_patient_user.slug}/home"
  end

end
