class Comment < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_any_word,
                  against: :body,
                  using: { tsearch: { any_word: true,
                                      sort_only: true,
                                      highlight: {
                                        StartSel: '<b>',
                                        StopSel: '</b>',
                                        MaxWords: 123,
                                        MinWords: 456,
                                        ShortWord: 4,
                                        HighlightAll: true,
                                        MaxFragments: 3,
                                        FragmentDelimiter: '&hellip;'
                                      } } }

  belongs_to :task
end
