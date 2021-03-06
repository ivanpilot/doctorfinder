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
    flash[:notice] = "Your profile has been updated."
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
      flash[:notice] = "This slot is already taken. Please choose another slot."
      redirect to "/doctors/#{current_doctor_user.slug}/appointment_new"
    else
      appointment.save
      current_doctor_user.book_appointment_with_patient(appointment: appointment, patient_name: params[:patient_name])
    end
    flash[:notice] = "Your appointment with #{params[:patient_name]} is booked."
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

    if current_doctor_user.slot_taken_to_update_appointment?(appointment_old:appointment_old, appointment_new:appointment_new)
      flash[:notice] = "This slot is already taken. Please select another slot."
      redirect to "/doctors/#{current_doctor_user.slug}/appointments/#{appointment_old.id}/edit"
    else
      appointment_old.cancel_appointment
      appointment_new.save
      current_doctor_user.book_appointment_with_patient(appointment: appointment_new, patient_name: patient_name)
    end
    flash[:notice] = "Your appointment with #{patient_name} has been rescheduled."
    redirect to "/doctors/#{current_doctor_user.slug}/home"
  end

  delete "/doctors/:slug/appointments/:id/delete" do
    appointment = Appointment.find(params[:id])
    if current_doctor_user.appointments_coming.include?(appointment)
      appointment.cancel_appointment
    end
      flash[:notice] = "Your appointment has been cancelled."
      redirect to "/"
  end

  get "/doctors/:slug/appointments_history" do
    if is_logged_in? && user_type? == "doctor"
      erb :'doctors/appointment_history'
    else
      redirect to "/"
    end
  end

  get "/doctors/:slug_doctor/patients/:slug_patient" do
    if is_logged_in? && user_type? == "doctor"
      @doctor = Doctor.find_by_slug(params[:slug_doctor])
      @patient = Patient.find_by_slug(params[:slug_patient])
      @appointments = @doctor.appointments_with(@patient)
      erb :"doctors/patient_appointments"
    else
      redirect to "/"
    end
  end

end
