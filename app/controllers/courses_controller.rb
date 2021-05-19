class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  def list
    user = params[:u]
    if User.where(id: user).exists?

      l = User.find(user).courses
      render json: l.to_json
    else
      msg = { :status => "error", :message => "User not found!"}
      render json: msg


    end


  end

  def enrollments
    course = params[:c]
    if Course.where(id: course).exists?

      l = Course.find(course).users
      render json: l.to_json
    else
      msg = { :status => "error", :message => "Course not found!"}
      render json: msg


    end


  end

  def deenroll
    course = params[:c]
    user = params[:u]


    if Subscription.where(user_id: user,course_id: course).exists?

      enrl = Course.find(course)

      if enrl.enrolled > 0
        Subscription.where(user_id: user,course_id: course).destroy_all
        enrl = Course.find(course)
        enrl.enrolled -= 1
        enrl.save
        render json: {:status => "success", :notice => "User de enrolled from this course!"}
      else
        render json: {:status => "error", :notice => "Somthing went wrong!"}
      end



    else
      render json: {:status => "error", :notice => "User is not a part of this course"}
    end
    
  end
  

  def enroll
    cid = params[:c]
    uid = params[:u]
    
    if not Subscription.where(user_id: uid,course_id: cid).exists?
      enrl = Course.find(cid)

      if enrl.enrolled >= enrl.seats
        render json: {:status => "error", :notice => "Can't enroll, no seats available!"}
         

      else



        @subs = Subscription.new
        @subs.user_id = uid
        @subs.course_id = cid
        @subs.save

        
        enrl.enrolled += 1
        enrl.save
        
        render json: {:status => "success", :notice => "User is now enrolled in this course!"}
        
      end

    else
      render json: {:status => "error", :notice => "You are already enrolled in this course!"}
      
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
