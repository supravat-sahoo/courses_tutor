class CoursesController < ApplicationController
  def index
    @courses = paginate(Course.includes(:tutors))
  end

  def create
    @course = Course.new(course_params)
    unless @course.save
      render status: :unprocessable_entity, json: { errors: @course.errors.full_messages }
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :title, :description,
      tutors_attributes: %i[first_name last_name email])
  end
end