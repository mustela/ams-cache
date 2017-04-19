class UsersController < ApplicationController
  def show
    render json: User.find(params[:id]), include: 'organizations'
  end
end
