require './config/environment'


use Rack::MethodOverride
# use Rack::Flash
use AppointmentsController
use DoctorsController
use PatientsController
run ApplicationController
