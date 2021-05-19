class HomeController < ApplicationController
  def index
  end

  def mycourses
    
  end

  def students
    render json: User.all.to_json
  end
end
