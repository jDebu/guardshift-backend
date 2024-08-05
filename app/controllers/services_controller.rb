class ServicesController < ApplicationController
  def index
    services = Service.all.map { |service| { label: service.name, value: service.id } }
    render json: { services: services }
  end
end
