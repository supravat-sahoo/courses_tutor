# frozen_string_literal: true

require "rails_helper"

RSpec.describe CoursesController, type: :request do
  describe "#index GET /courses" do
    let!(:course_one) { create(:course) }
    let!(:tutor_one) { create(:tutor, course: course_one) }
    let!(:tutor_two) { create(:tutor, course: course_one) }
    let!(:course_two) { create(:course) }
    let!(:tutor_three) { create(:tutor, course: course_two) }

    context "with GET to 'courses'" do
      it "returns all courses with their tutors" do
        get courses_path, headers: { "ACCEPT" => "application/json" }
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)

        expect(response_body.count).to eq 2
        expect(response_body.first["tutors"].count).to eq 2
        expect(response_body.last["tutors"].count).to eq 1

      end

      it "returns correct response for course & its tutors" do
        get courses_path, headers: { "ACCEPT" => "application/json" }, params: {}
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)

        expect(response_body.first["id"]).to eq course_one.id
        expect(response_body.first["tutors"].first["id"]).to eq tutor_one.id
        expect(response_body.first["tutors"].last["id"]).to eq tutor_two.id
        expect(response_body.last["id"]).to eq course_two.id
        expect(response_body.last["tutors"].first["id"]).to eq tutor_three.id
      end

      it "paginates the courses" do
        get courses_path, headers: { "ACCEPT" => "application/json" }, params: { page_size: 1, page_no: 2 }
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq 1
        expect(response_body.first["id"]).to eq course_two.id

        get courses_path, headers: { "ACCEPT" => "application/json" }, params: { page_size: 2, page_no: 1 }
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq 2
        expect(response_body.first["id"]).to eq course_one.id
        expect(response_body.last["id"]).to eq course_two.id

        get courses_path, headers: { "ACCEPT" => "application/json" }, params: { page_size: 2, page_no: 2 }
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq 0
      end
    end
  end

  describe "#create POST /courses" do
    let(:course) {
      {
        title: "Course 1",
        description: "Course 1 description",
        tutors_attributes: [{
                              first_name: "Test",
                              last_name: "One",
                              email: "test1@example.com"
                            },
                            {
                              "first_name": "Test",
                              "last_name": "Two",
                              "email": "test2@example.com"
                            }]
      }
    }
    let(:course_params) do
      {
        course: course
      }
    end

    subject { post courses_path, headers: { "ACCEPT" => "application/json" }, params: course_params }

    context "when valid params are passed" do
      it "creates the course with its tutors successfully" do
        subject
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)

        expect(response_body["notice"]).to eq "Course & its tutors are added successfully"
        expect(Course.count).to eq 1
        expect(Tutor.count).to eq 2
      end

    end

    context "when only courses are passed" do
      let(:course) {
        {
          title: "Course 2",
          description: "Description of course 2"
        }
      }
      it "create source successfully" do
        subject
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)

        expect(response_body["notice"]).to eq "Course & its tutors are added successfully"
        expect(Course.count).to eq 1
        expect(Tutor.count).to eq 0
      end
    end

    context "when same tutor has passed" do
      let!(:course_one) { create(:course) }
      let!(:tutor_one) { create(:tutor, course: course_one) }

      let(:course) {
        {
          title: "Course 2",
          description: "Description of course 2",
          tutors_attributes: [{
                                first_name: "Test",
                                last_name: "One",
                                email: tutor_one.email
                              }]
        }
      }
      it "show error message" do
        subject
        expect(response).to have_http_status(422)
        response_body = JSON.parse(response.body)

        expected_errors = ["Tutors email has already been taken"]
        expect(response_body["errors"]).to match_array expected_errors
      end
    end

    context "when empty params are passed" do
      let(:course) {
        {
          title: "",
          description: "",
          tutors_attributes: [{
                                first_name: "",
                                last_name: "",
                                email: ""
                              }]
        }
      }
      it "validates the empty params" do
        subject
        expect(response).to have_http_status(422)
        response_body = JSON.parse(response.body)

        expected_errors = ["Tutors first name can't be blank",
                           "Tutors last name can't be blank",
                           "Tutors email can't be blank",
                           "Tutors email is invalid",
                           "Title is too short (minimum is 3 characters)"]
        expect(response_body["errors"]).to match_array expected_errors
      end
    end

    context "when params are invalid" do
      let(:course) {
        {
          title: "title",
          description: "desc",
          tutors_attributes: [{
                                first_name: "Test",
                                last_name: "user",
                                email: "test@"
                              }]
        }
      }
      it "validates the invalid params" do
        subject
        expect(response).to have_http_status(422)
        response_body = JSON.parse(response.body)

        expected_errors = ["Tutors email is invalid"]
        expect(response_body["errors"]).to match_array expected_errors
      end
    end
  end
end