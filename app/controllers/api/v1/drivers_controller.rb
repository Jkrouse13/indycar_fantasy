class Api::V1::DriversController < ApplicationController
  def index
    drivers = Driver.includes(:team).all
    render json: drivers, include: :team
  end

  def show
    driver = Driver.includes(:team).find(params[:id])
    render json: driver, include: :team
  end

  def create
    driver = Driver.new(driver_params)
    if driver.save
      render json: driver, status: :created
    else
      render json: driver.errors, status: :unprocessable_entity
    end
  end

  def update
    driver = Driver.find(params[:id])
    if driver.update(driver_params)
      render json: driver
    else
      render json: driver.errors, status: :unprocessable_entity
    end
  end

  def destroy
    Driver.find(params[:id]).destroy
    head :no_content
  end

  private

  def driver_params
    params.require(:driver).permit(:name, :car_number, :team_id)
  end
end