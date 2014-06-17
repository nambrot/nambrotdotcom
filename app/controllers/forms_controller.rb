class FormsController < ApplicationController

  def hire
    FormMailer.hire_email(params).deliver
    render json: {status: 'OK'}
  end
  
  def fire
    FormMailer.fire_email(params).deliver
    render json: {status: 'OK'}
  end
end
