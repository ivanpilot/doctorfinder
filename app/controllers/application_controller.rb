class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "doctor_secret"
  end

  get '/' do
    erb :index
  end

  post "/signup/doctors" do
    puts "this is the params"
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      redirect to "/"
    else
      doctor = Doctor.new(name: params[:name], email: params[:email], password: params[:password])
      if doctor.save
        session[:id] = doctor.id
        redirect to "/doctors/home"
      else
        redirect to "/"
      end
    end
  end




  helpers do

    def is_logged_in?
      !!session[:id]
    end

    def current_doctor_user
      Doctor.find(session[:id])
    end

    def current_patient_user
      Patient.find(session[:id])
    end

  end

end
