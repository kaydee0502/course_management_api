class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  #before_action :authenticate_user!, except: [:index,:show]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
  end


  def deenroll
    course = params[:c]
    user = params[:u]


    if Subscription.where(user_id: current_user.id,course_id: course).exists?

      enrl = Course.find(course)

      if enrl.enrolled > 0
        Subscription.where(user_id: user,course_id: course).destroy_all
        enrl = Course.find(course)
        enrl.enrolled -= 1
        enrl.save
        redirect_to request.referrer, :notice => "User de enrolled from this course!"
      else
        redirect_to request.referrer, :notice => "Can't de enroll, something went wrong!"
      end



    else
      redirect_to request.referrer, :notice => "You are not a part of this course!"
    end
    
  end
  

  def enroll
    course = params[:c]
    
    if not Subscription.where(user_id: current_user.id,course_id: course).exists?
      enrl = Course.find(course)

      if enrl.enrolled >= enrl.seats
        redirect_to request.referrer, :notice => "Can't enroll, no seats available!"

      else



        @subs = Subscription.new
        @subs.user_id = current_user.id
        @subs.course_id = course
        @subs.save

        
        enrl.enrolled += 1
        enrl.save
        redirect_to request.referrer, :notice => "You are now enrolled in this course!"
      end

    else
      redirect_to request.referrer, :notice => "You are already enrolled in this course!"
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
