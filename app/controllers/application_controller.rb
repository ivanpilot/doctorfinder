class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "doctor_secret"
  end

  get '/' do
    if is_logged_in? && current_doctor_user
      doctor = current_doctor_user
      redirect to "/doctors/#{doctor.slug}/home"
    elsif is_logged_in? && current_patient_user
      patient = current_patient_user
      redirect to "/patients/#{patient.slug}/home"
    else
      erb :index
  end

  post "/signup/doctors" do
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      redirect to "/"
    else
      doctor = Doctor.new(name: params[:name], email: params[:email], password: params[:password])
      if doctor.save
        session[:id] = doctor.id
        redirect to "/doctors/#{doctor.slug}/home"
      else
        redirect to "/"
      end
    end
  end

  post "/signup/patients" do
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      redirect to "/"
    else
      patient = Patient.new(name: params[:name], email: params[:email], password: params[:password])
      if patient.save
        session[:id] = patient.id
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
      redirect to "/doctors/#{doctor.slug}/home"
    elsif patient && patient.authenticate(params[:password])
      session[:id] = patient.id
      redirect to "/patients/#{patient.slug}/home"
    else
      redirect to "/"
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
