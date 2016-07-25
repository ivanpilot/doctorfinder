class DoctorsController < ApplicationController

  get "/doctors/home" do
    if is_logged_in?
      erb :'doctors/home'
    else
      redirect to "/"
    end
  end

end
