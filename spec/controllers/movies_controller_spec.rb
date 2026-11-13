require 'spec_helper'
require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  let(:valid_attributes) { { title: 'Star Wars', rating: 'PG', release_date: '1977-05-25', director: 'George Lucas' } }
  let(:alien_attributes)  { { title: 'Alien', rating: 'R', release_date: '1979-05-25', director: nil } }

  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns all movies when no rating filter' do
      Movie.create!(valid_attributes)
      get :index
      expect(assigns(:movies)).to include(Movie.first)
    end

    it 'filters movies by selected ratings' do
      Movie.create!(valid_attributes)
      Movie.create!(title: 'Alien', rating: 'R', release_date: '1979-05-25')
      get :index, params: { ratings: { 'PG' => '1' } }
      ratings = assigns(:movies).map(&:rating).uniq
      expect(ratings).to eq(['PG'])
    end

    it 'orders movies by title when sort_by=title' do
      Movie.create!(title: 'Zorro', rating: 'PG', release_date: '1998-01-01')
      Movie.create!(title: 'Aladdin', rating: 'G', release_date: '1992-01-01')
      get :index, params: { sort_by: 'title', ratings: { 'PG' => '1', 'G' => '1' } }
      expect(assigns(:movies).first.title).to eq('Aladdin')
    end

    it 'ignores invalid sort_by values' do
      get :index, params: { sort_by: 'evil_column' }
      expect(assigns(:sort_by)).to be_nil
    end
  end

  describe 'GET show' do
    it 'renders the show template' do
      movie = Movie.create!(valid_attributes)
      get :show, params: { id: movie.id }
      expect(response).to render_template(:show)
      expect(assigns(:movie)).to eq(movie)
    end
  end

  describe 'GET new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET edit' do
    it 'renders the edit template' do
      movie = Movie.create!(valid_attributes)
      get :edit, params: { id: movie.id }
      expect(response).to render_template(:edit)
      expect(assigns(:movie)).to eq(movie)
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'redirects to movies path' do
        post :create, params: { movie: valid_attributes }
        expect(response).to redirect_to(movies_path)
      end

      it 'creates a new movie' do
        expect {
          post :create, params: { movie: valid_attributes }
        }.to change(Movie, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'renders new with 422' do
        post :create, params: { movie: { title: '', rating: 'PG', release_date: Date.today } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH update' do
    context 'with valid attributes' do
      it 'redirects to the movie page' do
        movie = Movie.create!(valid_attributes)
        patch :update, params: { id: movie.id, movie: { title: 'Star Wars Updated', director: 'G. Lucas' } }
        expect(response).to redirect_to(movie_path(movie))
      end

      it 'updates the movie attributes' do
        movie = Movie.create!(valid_attributes)
        patch :update, params: { id: movie.id, movie: { director: 'Updated Director' } }
        expect(movie.reload.director).to eq('Updated Director')
      end
    end

    context 'with invalid attributes' do
      it 'renders edit with 422' do
        movie = Movie.create!(valid_attributes)
        patch :update, params: { id: movie.id, movie: { title: '', rating: 'PG', release_date: Date.today } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the movie and redirects' do
      movie = Movie.create!(valid_attributes)
      expect {
        delete :destroy, params: { id: movie.id }
      }.to change(Movie, :count).by(-1)
      expect(response).to redirect_to(movies_path)
    end
  end

  describe 'POST search_tmdb' do
    it 'sets flash notice and redirects to movies path' do
      post :search_tmdb, params: { search_terms: 'Unknown Movie' }
      expect(flash[:notice]).to match(/Unknown Movie/)
      expect(response).to redirect_to(movies_path)
    end
  end

  describe 'GET same_director' do
    context 'when the specified movie has a director' do
      it 'calls Movie.with_same_director and assigns @movies' do
        movie = Movie.create!(valid_attributes)
        similar = Movie.create!(title: 'THX-1138', rating: 'R', release_date: '1971-03-11', director: 'George Lucas')
        expect(Movie).to receive(:with_same_director).with(movie).and_call_original
        get :same_director, params: { id: movie.id }
        expect(assigns(:movies)).to include(similar)
        expect(response).to render_template(:same_director)
      end
    end

    context 'when the specified movie has no director' do
      it 'redirects to movies_path with a flash notice' do
        movie = Movie.create!(alien_attributes)
        get :same_director, params: { id: movie.id }
        expect(response).to redirect_to(movies_path)
        expect(flash[:notice]).to eq("'Alien' has no director info")
      end
    end
  end
end
