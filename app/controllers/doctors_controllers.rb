class DoctorsController < ApplicationController

  get "/doctors/:slug/home" do
    if is_logged_in? && user_type? == "doctor"
      @doctor = Doctor.find(session[:id])
      erb :'doctors/home'
    else
      redirect to "/"
    end
  end

end
