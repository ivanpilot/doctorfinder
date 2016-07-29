Specialty.create(name: "Generalist")
Specialty.create(name: "Psychologist")
Specialty.create(name: "Ophthalmologist")
Specialty.create(name: "Dentist")

Doctor.create(name: "doctor", email: "doctor@gmail.com", password: "doctor")
# Doctor.create(name: "Joe", email: "joe@gmail.com", password: "joe")
# Doctor.create(name: "Mike", email: "mike@gmail.com", password: "mike")
# Doctor.create(name: "Rob", email: "rob@gmail.com", password: "rob")
# Doctor.create(name: "David", email: "david@gmail.com", password: "david")
#
Patient.create(name: "patient", email: "patient@gmail.com", password: "patient")
# Patient.create(name: "Sophie", email: "sophie@gmail.com", password: "sophie")
# Patient.create(name: "Anna", email: "anna@gmail.com", password: "anna")
# Patient.create(name: "John", email: "john@gmail.com", password: "john")

Appointment.new(start: DateTime.new(2016, 8, 20, 13, 30), end: DateTime.new(2016, 8, 20, 14, 30))
