require 'spec_helper'
require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'validations' do
    it 'is invalid without a title' do
      movie = Movie.new(rating: 'PG', release_date: Date.today)
      expect(movie).not_to be_valid
    end

    it 'is invalid with an unrecognized rating' do
      movie = Movie.new(title: 'Test', rating: 'XX', release_date: Date.today)
      expect(movie).not_to be_valid
    end

    it 'is invalid without a release date' do
      movie = Movie.new(title: 'Test', rating: 'PG')
      expect(movie).not_to be_valid
    end

    it 'is valid with title, valid rating, and release date' do
      movie = Movie.new(title: 'Test', rating: 'PG', release_date: Date.today)
      expect(movie).to be_valid
    end
  end

  describe '.all_ratings' do
    it 'returns the list of valid ratings' do
      expect(Movie.all_ratings).to eq(%w[G PG PG-13 R NC-17])
    end
  end

  describe '.with_same_director' do
    let!(:star_wars)    { Movie.create!(title: 'Star Wars',    rating: 'PG', director: 'George Lucas', release_date: '1977-05-25') }
    let!(:thx_1138)     { Movie.create!(title: 'THX-1138',     rating: 'R',  director: 'George Lucas', release_date: '1971-03-11') }
    let!(:blade_runner) { Movie.create!(title: 'Blade Runner', rating: 'PG', director: 'Ridley Scott',  release_date: '1982-06-25') }
    let!(:alien)        { Movie.create!(title: 'Alien',        rating: 'R',  director: nil,             release_date: '1979-05-25') }

    it 'finds movies by the same director' do
      result = Movie.with_same_director(star_wars)
      expect(result).to include(thx_1138)
    end

    it 'does not find movies by different directors' do
      result = Movie.with_same_director(star_wars)
      expect(result).not_to include(blade_runner)
    end

    it 'does not include the movie itself' do
      result = Movie.with_same_director(star_wars)
      expect(result).not_to include(star_wars)
    end

    it 'returns empty when director is blank' do
      result = Movie.with_same_director(alien)
      expect(result).to be_empty
    end
  end
end
