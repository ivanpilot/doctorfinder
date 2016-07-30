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
    appointment = Appointment.instantiate_appointment(params[:appointment_date])

    if current_doctor_user.slot_taken?(appointment) || params[:patient_name].empty?
      redirect to "/doctors/#{current_doctor_user.slug}/appointment_new"
      ######## SHOW A BOX DIALOGUE !!!!!!!!!!!!!!
    else
      appointment.save
      current_doctor_user.book_appointment_with_patient(appointment, params[:patient_name])
    end

    redirect to "/doctors/#{current_doctor_user.slug}/home"
  end

  get "/doctors/:slug/appointments/:id/edit" do
    @appointment = Appointment.find(params[:id])
    if is_logged_in? && user_type? == "doctor" && current_doctor_user.appointments_coming.include?(@appointment)
        erb :'doctors/appointment_edit'
    else
      redirect to "/"
    end
  end

  patch "/doctors/:slug/appointments/:id/edit" do
    appointment_old = Appointment.find(params[:id])
    patient_name = appointment_old.details[:patients].first.name
    appointment_new = Appointment.instantiate_appointment(params[:appointment_date])

    if current_doctor_user.slot_taken?(appointment_new)
      redirect to "/doctors/#{current_doctor_user.slug}/appointments/#{appointment_old.id}/edit"
      ######## SHOW A BOX DIALOGUE !!!!!!!!!!!!!!
    else
      appointment_old.cancel_appointment
      appointment_new.save
      current_doctor_user.book_appointment_with_patient(appointment_new, patient_name)
    end

    redirect to "/doctors/#{current_doctor_user.slug}/home"
  end

end
