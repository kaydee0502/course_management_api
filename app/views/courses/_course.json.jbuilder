json.extract! course, :id, :name, :seats, :enrolled, :description, :created_at, :updated_at
json.url course_url(course, format: :json)
