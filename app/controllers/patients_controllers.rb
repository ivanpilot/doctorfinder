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

    if params[:doctor]
      doctor = Doctor.find_by_name_or_specialty_id(name: params[:doctor][:name], specialty_id: params[:doctor][:specialty_id])

      if doctor.class == Array
        if doctor.empty?
          flash[:notice] = "We are sorry but there is no available doctors with that specialty."
          redirect to "/patients/#{current_patient_user.slug}/appointment_new"
        else
          doctor = doctor.first {|doc| doc.slot_free?(appointment)}
        end
      end

      if doctor.slot_free?(appointment)
        appointment.save
        current_patient_user.book_appointment_with_doctor(appointment: appointment, doctor_name: doctor.name)
        redirect to "/patients/#{current_patient_user.slug}/home"
      else
        flash[:notice] = "We are sorry but there is no availability for this specific specialist with such a date and time."
        redirect to "/patients/#{current_patient_user.slug}/appointment_new"
      end

    else
      flash[:notice] = "Please select a doctor either by name or specialty to book an appointment."
      redirect to "/patients/#{current_patient_user.slug}/appointment_new"
    end
  end

  get "/patients/:slug/appointments/:id/edit" do
    @appointment = Appointment.find(params[:id])
    if is_logged_in? && user_type? == "patient" && current_patient_user.appointments_coming.include?(@appointment)
        erb :'patients/appointment_edit'
    else
      redirect to "/"
    end
  end

  patch "/patients/:slug/appointments/:id/edit" do
    appointment_old = Appointment.find(params[:id])
    doctor = appointment_old.details[:doctors].first
    appointment_new = Appointment.instantiate_appointment(params[:appointment_date])

    if doctor.slot_taken?(appointment_new)
      flash[:notice] = "The Doctor #{doctor.name} is not available for this slot. Please select another slot."
      redirect to "/patients/#{current_patient_user.slug}/appointments/#{appointment_old.id}/edit"
    else
      appointment_old.cancel_appointment
      appointment_new.save
      current_patient_user.book_appointment_with_doctor(appointment: appointment_new, doctor_name: doctor.name)
    end
    flash[:notice] = "Your appointment with #{doctor.name} has been rescheduled."
    redirect to "/patients/#{current_patient_user.slug}/home"
  end

  get "/patients/:slug/appointments_history" do
    if is_logged_in? && user_type? == "patient"
      erb :'patients/appointment_history'
    else
      redirect to "/"
    end
  end



end

# params = {
#   "doctor"=>{
#     "name"=>"doctor",
#     "specialty"=>"1"
#   },
#   "appointment_date"=>{
#     "day"=>"3",
#     "month"=>"11",
#     "year"=>"2016",
#     "hour"=>"8",
#     "minute"=>"0"
#   },
#   "splat"=>[],
#   "captures"=>["patient"],
#   "slug"=>"patient"
# }
