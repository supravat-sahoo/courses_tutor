class CoursesController < ApplicationController
  before_action :load_courses_with_tutors, only: :index

  def index
    render
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      render
    else
      render status: :unprocessable_entity, json: { errors: @course.errors.full_messages }
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :title, :description,
      tutors_attributes: %i[first_name last_name email])
  end

  def load_courses_with_tutors
    page_no = params[:page_no] || 1
    page_size = params[:page_size] || 10
    @courses = Course.includes(:tutors).offset(Integer(page_size) * (Integer(page_no) - 1)).limit(Integer(page_size))
  end
end