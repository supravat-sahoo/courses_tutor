json.notice "Course & its tutors are added successfully"
json.extract! @course, :id, :title, :description
json.tutors @course.tutors do |tutor|
  json.extract! tutor, :id, :first_name, :last_name, :email
end