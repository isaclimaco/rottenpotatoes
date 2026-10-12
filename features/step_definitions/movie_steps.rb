Given('I have added the movies {string} rated {string} and {string} rated {string}') do |title1, rating1, title2, rating2|
  # Modo "direto no banco": cria os filmes com o model, sem passar pela interface.
  # A data de lançamento é obrigatória (validação), então usamos a data de hoje.
  Movie.create!(title: title1, rating: rating1, release_date: Date.today)
  Movie.create!(title: title2, rating: rating2, release_date: Date.today)
end

When('I sort the movies by title') do
  # 1. abrir a lista de filmes
  visit(movies_path)
  # 2. clicar no cabeçalho para ordenar
  click_link('Movie Title')
end