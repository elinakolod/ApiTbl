# frozen_string_literal: true

namespace :elasticsearch do
  task create_indexes: :environment do
    Project.import(force: true)
    Task.import(force: true)
    Comment.import(force: true)
  end
end
