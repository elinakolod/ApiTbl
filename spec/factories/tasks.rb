FactoryBot.define do
  factory :task do
    name { 'name' }
    done { false }
    project
  end
end
