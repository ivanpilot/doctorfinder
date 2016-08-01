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

  

end
