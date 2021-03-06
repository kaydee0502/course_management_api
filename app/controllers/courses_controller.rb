class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy enroll deenroll]
  before_action :authenticate_user!

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    a = @course.users
    output = Hash.new
    a.each do |key, value|
      output[key] = value
    end
   
    
    render json: @course.to_json(:include => { :users => output })
    
    #respond_to do |format|
    #  format.json { render :show, status: :ok, kas: "lol" }
    #end
  end

 
 

  def deenroll
    
   

    if User.where(id: params[:u]).exists? && Course.where(id: params[:id]).exists?

      @user = User.find(params[:u])
      @course = Course.find(params[:id])
      


        if Subscription.where(user_id: @user.id,course_id: @course.id).exists?

          

          if @course.enrolled > 0
            Subscription.where(user_id: @user.id,course_id: @course.id).destroy_all
            
            @course.enrolled -= 1
            @course.save
            render json: {:status => "success", :notice => "User de enrolled from this course!"}
          else
            render json: {:status => "error", :notice => "Something went wrong!"}
          end
        else
          render json: {:status => "error", :notice => "User is not a part of this cousre"}
        end



    else
      render json: {:status => "error", :notice => "No such user or course"}
    end
    
  end
  

  def enroll
  
  
    if User.where(id: params[:u]).exists? && Course.where(id: params[:id]).exists?

      @user = User.find(params[:u])
      @course = Course.find(params[:id])
    
      if not Subscription.where(user_id: @user.id,course_id: @course.id).exists?
        if @course.enrolled >= @course.seats
          render json: {:status => "error", :notice => "Can't enroll, no seats available!"}
        else



          @subs = Subscription.new
          @subs.user_id = @user.id
          @subs.course_id = @course.id
          @subs.save
  
          
          @course.enrolled += 1
          @course.save
          
          render json: {:status => "success", :notice => "User is now enrolled in this course!"}
          
        end
      

      else
        render json: {:status => "error", :notice => "You are already enrolled in this course!"}

      end
      




    else
      render json: {:status => "error", :notice => "No such user or course"}

    end
    
    
  end







  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :seats, :enrolled, :description)
      
    end

    def subs_params
      params.require(:subscriptions).permit(:id, :user_id, :course_id, :created_at, :updated_at)
    end
end
