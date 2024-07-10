# frozen_string_literal: true

require "rails_helper"

RSpec.describe CoursesController, type: :request do
  # describe "create courses with its tutors" do
  #   let(:course_params) do
  #     {
  #       course: {
  #         title: "Course 1",
  #         description: "Course 1 description",
  #         tutors_attributes: [{
  #                               first_name: "Test",
  #                               last_name: "One",
  #                               email: "test1@example.com"
  #                             },
  #                             {
  #                               "first_name": "Test",
  #                               "last_name": "Two",
  #                               "email": "test2@example.com"
  #                             }]
  #       }
  #     }
  #   end
  #   context "POST to 'courses'" do
  #     it "creates the course with its tutors successfully" do
  #       post :create, params: course_params
  #       expect(response).to have_http_status(200)
  #       response_body = JSON.parse(response.body)
  #
  #       expect(response_body["notice"]).to eq "Course & its tutors are added successfully"
  #       expect(Course.count).to eq 1
  #       expect(Tutor.count).to eq 2
  #     end
  #
  #     it "validates the empty params" do
  #       params = {
  #         course: {
  #           title: "",
  #           description: "",
  #           tutors_attributes: [{
  #                                 first_name: "",
  #                                 last_name: "",
  #                                 email: ""
  #                               }]
  #         }
  #       }
  #       post(:create, params: params)
  #       expect(response).to have_http_status(422)
  #       response_body = JSON.parse(response.body)
  #
  #       expected_errors = ["Tutors first name can't be blank",
  #                          "Tutors last name can't be blank",
  #                          "Tutors email can't be blank", "Tutors email is invalid",
  #                          "Title is too short (minimum is 3 characters)"]
  #       expect(response_body["errors"]).to match_array expected_errors
  #     end
  #
  #     it "validates the invalid params" do
  #       params = {
  #         course: {
  #           title: "title",
  #           description: "desc",
  #           tutors_attributes: [{
  #                                 first_name: "Test",
  #                                 last_name: "user",
  #                                 email: "test@"
  #                               }]
  #         }
  #       }
  #       post(:create, params: params)
  #       expect(response).to have_http_status(422)
  #       response_body = JSON.parse(response.body)
  #
  #       expected_errors = ["Tutors email is invalid",
  #                          "Title is too short (minimum is 3 characters)"]
  #       expect(response_body["errors"]).to match_array expected_errors
  #     end
  #   end
  # end

  describe "get courses with its tutors" do
    let!(:course_one) { create(:course) }
    let!(:tutor_one) { create(:tutor, course: course_one) }
    let!(:tutor_two) { create(:tutor, course: course_one) }
    let!(:course_two) { create(:course) }
    let!(:tutor_three) { create(:tutor, course: course_two) }

    context "with GET to 'courses'" do
      it "returns all courses with their tutors" do
        get :index
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)

        expect(response_body.count).to eq 2
        expect(response_body.first["tutors"].count).to eq 2
        expect(response_body.last["tutors"].count).to eq 1

      end

      it "returns correct response for course & its tutors" do
        get :index
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)

        expect(response_body.first["id"]).to eq course_one.id
        expect(response_body.first["tutors"].first["id"]).to eq tutor_one.id
        expect(response_body.first["tutors"].last["id"]).to eq tutor_two.id
        expect(response_body.last["id"]).to eq course_two.id
        expect(response_body.last["tutors"].first["id"]).to eq tutor_three.id
      end

      it "paginates the courses" do
        get :index, params: { page_size: 1, page_no: 2 }
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq 1
        expect(response_body.first["id"]).to eq course_two.id

        get :index, params: { page_size: 2, page_no: 1 }
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq 2
        expect(response_body.first["id"]).to eq course_one.id
        expect(response_body.last["id"]).to eq course_two.id

        get :index, params: { page_size: 2, page_no: 2 }
        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq 0
      end
    end
  end

end