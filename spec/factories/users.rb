FactoryBot.define do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    sequence :email do |n|
      "fuckyou#{n}@email.com"
    end
    password { 'DirtyBitch1' }
  end
end
