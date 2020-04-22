# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


5.times do
  user = User.create(email: FFaker::Internet.email, password: '123456')
  5.times do
    project = Project.create(name: FFaker::Lorem.word, user_id: user.id)
    5.times do
      task = Task.create(name: FFaker::Lorem.sentence, project_id: project.id)
      5.times do
        Comment.create(body: FFaker::Lorem.paragraphs(3), task_id: task.id)
      end
    end
  end
end
