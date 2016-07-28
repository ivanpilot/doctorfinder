require './config/environment'

use Rack::MethodOverride
use AppointmentsController
use DoctorsController
use PatientsController
run ApplicationController
