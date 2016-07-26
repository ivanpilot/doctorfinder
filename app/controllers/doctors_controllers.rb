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

end
