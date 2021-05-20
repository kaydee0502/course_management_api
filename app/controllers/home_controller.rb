class HomeController < ApplicationController
  def index
  end

  def mycourses
    
  end

  def students
    q = params[:id]
    if !(params.has_key?(:id))
      render json: User.all.to_json

    else
      user = User.find(q)
      courses = User.find(q).courses
      output = Hash.new
      courses.each do |key, value|
        output[key] = value
      end


      render json: user.to_json(:include => { :courses => output })



    end
  end
end
