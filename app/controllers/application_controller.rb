class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "doctor_secret"
    require 'rack-flash'
    use Rack::Flash
  end

  get '/' do
    if is_logged_in? && user_type? == "doctor"
      redirect to "/doctors/#{current_doctor_user.slug}/home"
    elsif is_logged_in? && user_type? == "patient"
      redirect to "/patients/#{current_patient_user.slug}/home"
    else
      erb :index
    end
  end

  post "/signup/doctors" do
    if params[:doctor][:name].empty? || params[:doctor][:email].empty? || params[:doctor][:password].empty?
      redirect to "/"
    else
      doctor = Doctor.new(params[:doctor])

      if doctor.save
        session[:id] = doctor.id
        session[:user_type] = doctor.user_type
        redirect to "/doctors/#{doctor.slug}/home"
      else
        redirect to "/"
      end

    end
  end

  post "/signup/patients" do
    if params[:patient][:name].empty? || params[:patient][:email].empty? || params[:patient][:password].empty?
      redirect to "/"
    else
      patient = Patient.new(params[:patient])

      if patient.save
        session[:id] = patient.id
        session[:user_type] = patient.user_type
        redirect to "/patients/#{patient.slug}/home"
      else
        redirect to "/"
      end

    end
  end

  post "/login" do
    doctor = Doctor.find_by(name: params[:name])
    patient = Patient.find_by(name: params[:name])

    if doctor && doctor.authenticate(params[:password])
      session[:id] = doctor.id
      session[:user_type] = doctor.user_type
      redirect to "/doctors/#{doctor.slug}/home"
    elsif patient && patient.authenticate(params[:password])
      session[:id] = patient.id
      session[:user_type] = patient.user_type
      redirect to "/patients/#{patient.slug}/home"
    else
      redirect to "/"
    end
  end

  get "/logout" do
    if is_logged_in?
      session.clear
    end
      redirect to "/"
  end


  helpers do
    def is_logged_in?
      !!session[:id]
    end

    def user_type?
      session[:user_type]
    end

    def current_doctor_user
      Doctor.find(session[:id])
    end

    def current_patient_user
      Patient.find(session[:id])
    end


  end
end
