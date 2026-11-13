class Movie < ApplicationRecord
  RATINGS = %w[G PG PG-13 R NC-17].freeze

  validates :title, presence: true
  validates :rating, inclusion: { in: RATINGS }
  validates :release_date, presence: true

  def self.all_ratings
    RATINGS
  end

  def self.with_same_director(movie)
    return none if movie.director.blank?
    where(director: movie.director).where.not(id: movie.id)
  end
end
