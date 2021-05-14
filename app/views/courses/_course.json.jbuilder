json.extract! course, :id, :name, :seats, :enrolled, :created_at, :updated_at
json.url course_url(course, format: :json)
