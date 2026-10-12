module NavigationHelpers
  def path_to(page_name)
    case page_name
    when "the RottenPotatoes home page"
      movies_path
    when "the Create New Movie page"
      new_movie_path
    else
      raise "Não sei o caminho da página: #{page_name}"
    end
  end
end

World(NavigationHelpers)