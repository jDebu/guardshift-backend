employees = Employee.create([
  { name: 'Ernesto', color: '#ebb37c' },
  { name: 'Bárbara', color: '#b7809e' },
  { name: 'Benjamín', color: '#76a0e1' }
])

services = Service.create([
  { name: 'Monitoreo Recorrido.cl', week_start_time: '19:00', week_end_time: '00:00', weekend_start_time: '10:00', weekend_end_time: '00:00' }
])

availabilities = Availability.create([
  { employee: employees.first, service: services.first, date: '2024-08-05', start_time: '19:00', end_time: '21:00' },
  { employee: employees.second, service: services.first, date: '2024-08-05', start_time: '21:00', end_time: '00:00' },
  { employee: employees.third, service: services.first, date: '2024-08-06', start_time: '19:00', end_time: '22:00' }
])
