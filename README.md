# Assignment

It's a rails application that allows users to create & list courses along with their tutors. This project includes two API's:
* Common POST API to create a course & its tutors
* GET API to list all the courses along with their tutors

## Pre-requisites
It uses `Ruby`, `Ruby on Rails` and `Postgresql` for the database.

## Getting started
1. Clone the repository.
2. Run `bundle install`
3. Run `bundle exec rails server` to start the Rails server.
4. Run `bundle exec rspec` to run the Rspec tests for the API's.

## API's

### 1. Get list of courses with its tutors `GET courses`
#### For pagination add `page_size` & `page_no` params such as `courses?page_size=5&page_no=2`
#### `Response`
```json
[
    {
        "id": "1",
        "title": "Test title",
        "description": "Test description",
        "tutors": [
            {
                "id": "1",
                "first_name": "Test",
                "last_name": "One",
                "email": "test1@example.com"
            },
            {
                "id": "2",
                "first_name": "Test",
                "last_name": "Two",
                "email": "test2@example.com"
            }
        ]
    },
    {
        "id": "2",
        "title": "Test title 2",
        "description": "Test description 2",
        "tutors": [
            {
                "id": "3",
                "first_name": "Test",
                "last_name": "Three",
                "email": "test3@example.com"
            },
            {
                "id": "4",
                "first_name": "Test",
                "last_name": "Four",
                "email": "test4@example.com"
            }
        ]
    }
]
```

### 2. Create course with its tutors `POST courses`

#### `Request Payload`
```json
{
    "course": {
        "title": "Test title",
        "description": "Test description",
        "tutors_attributes": [{
            "first_name": "Test",
            "last_name": "One",
            "email": "test1@example.com"
        },
        {
            "first_name": "Test",
            "last_name": "Two",
            "email": "test2@example.com"
        }]
    }
}
```

#### `Response`
```json
{
    "notice": "Course & its tutors are added successfully",
    "id": "1",
    "title": "Test title",
    "description": "Test description",
    "tutors": [
        {
            "id": "1",
            "first_name": "Test",
            "last_name": "One",
            "email": "test1@example.com"
        },
        {
            "id": "2",
            "first_name": "Test",
            "last_name": "Two",
            "email": "test2@example.com"
        }
    ]
}
```
