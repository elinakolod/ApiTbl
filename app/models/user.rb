class User < ApplicationRecord
  include PgSearch::Model

  # Dynamic search scopes
  pg_search_scope :search_by_name, lambda { |name_part, query|
    raise ArgumentError unless %i[first_name last_name].include?(name_part)

    {
      against: name_part,
      query: query
    }
  }

  # Full Text Search (Weighting)
  pg_search_scope :search_user_full_text, against: {
    email: 'A',
    last_name: 'B',
    first_name: 'C'
  }

  devise :database_authenticatable, :registerable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy
end
