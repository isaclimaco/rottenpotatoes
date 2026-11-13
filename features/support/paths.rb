module NavigationHelpers
  def path_to(page_name)
    case page_name
    when "the RottenPotatoes home page", "the home page"
      movies_path
    when "the Create New Movie page"
      new_movie_path
    when /^the edit page for "(.*)"$/
      edit_movie_path(Movie.find_by!(title: $1))
    when /^the details page for "(.*)"$/
      movie_path(Movie.find_by!(title: $1))
    when /^the Similar Movies page for "(.*)"$/
      same_director_movie_path(Movie.find_by!(title: $1))
    else
      raise "Não sei o caminho da página: #{page_name}"
    end
  end
end

World(NavigationHelpers)