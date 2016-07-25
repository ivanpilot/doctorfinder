require './config/environment'

use Rack::MethodOverride
use DoctorsController
use PatientsController
run ApplicationController
