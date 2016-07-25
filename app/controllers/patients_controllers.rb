class PatientsController < ApplicationController

  get "/patients/:slug/home" do
    if is_logged_in?
      @patient = Patient.find(session[:id])
      erb :'patients/home'
    else
      redirect to "/"
    end
  end

end
