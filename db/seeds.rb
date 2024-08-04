employees = Employee.create([
  { name: 'Ernesto', color: '#ebb37c' },
  { name: 'Bárbara', color: '#b7809e' },
  { name: 'Benjamín', color: '#76a0e1' }
])

services = Service.create([
  { name: 'Monitoreo Recorrido.cl', week_start_time: '19:00', week_end_time: '00:00', weekend_start_time: '10:00', weekend_end_time: '00:00' }
])

availabilities = Availability.create([
  { employee: employees.third, service: services.first, date: '2020-03-02', start_time: '19:00', end_time: '00:00' },

  { employee: employees.third, service: services.first, date: '2020-03-03', start_time: '19:00', end_time: '00:00' },
  { employee: employees.second, service: services.first, date: '2020-03-03', start_time: '19:00', end_time: '00:00' },
  { employee: employees.first, service: services.first, date: '2020-03-03', start_time: '19:00', end_time: '00:00' },

  { employee: employees.second, service: services.first, date: '2020-03-04', start_time: '19:00', end_time: '00:00' },
  { employee: employees.third, service: services.first, date: '2020-03-04', start_time: '19:00', end_time: '00:00' },

  { employee: employees.third, service: services.first, date: '2020-03-05', start_time: '19:00', end_time: '00:00' },
  { employee: employees.second, service: services.first, date: '2020-03-05', start_time: '19:00', end_time: '00:00' },
  { employee: employees.first, service: services.first, date: '2020-03-05', start_time: '19:00', end_time: '00:00' },

  { employee: employees.first, service: services.first, date: '2020-03-06', start_time: '19:00', end_time: '00:00' },
  { employee: employees.second, service: services.first, date: '2020-03-06', start_time: '19:00', end_time: '00:00' },

  { employee: employees.first, service: services.first, date: '2020-03-07', start_time: '10:00', end_time: '15:00' },
  { employee: employees.second, service: services.first, date: '2020-03-07', start_time: '18:00', end_time: '21:00' },
  { employee: employees.third, service: services.first, date: '2020-03-07', start_time: '18:00', end_time: '00:00' },

  { employee: employees.second, service: services.first, date: '2020-03-08', start_time: '10:00', end_time: '00:00' },
])



shifts = Shift.create([
  { employee: employees.third, service: services.first, date: '2020-03-02', start_time: '19:00', end_time: '00:00' },
  { employee: employees.first, service: services.first, date: '2020-03-03', start_time: '19:00', end_time: '00:00' },
  { employee: employees.third, service: services.first, date: '2020-03-04', start_time: '19:00', end_time: '00:00' },
  { employee: employees.first, service: services.first, date: '2020-03-05', start_time: '19:00', end_time: '00:00' },
  { employee: employees.second, service: services.first, date: '2020-03-06', start_time: '19:00', end_time: '00:00' },

  { employee: employees.first, service: services.first, date: '2020-03-07', start_time: '10:00', end_time: '15:00' },
  { employee: employees.third, service: services.first, date: '2020-03-07', start_time: '18:00', end_time: '00:00' },

  { employee: employees.second, service: services.first, date: '2020-03-08', start_time: '10:00', end_time: '00:00' },
])
