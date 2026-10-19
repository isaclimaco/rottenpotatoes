Given('the following movies exist:') do |table|
  table.hashes.each do |row|
    Movie.create!(title: row['title'], rating: row['rating'],
                  release_date: Date.parse(row['release_date']))
  end
end

Given('I have added the movies {string} rated {string} and {string} rated {string}') do |title1, rating1, title2, rating2|
  Movie.create!(title: title1, rating: rating1, release_date: Date.today)
  Movie.create!(title: title2, rating: rating2, release_date: Date.today)
end

When('I sort the movies by title') do
  visit(movies_path)
  click_link('Movie Title')
end

Then('I should see {string} before {string}') do |first, second|
  first_pos = page.body.index(first)
  second_pos = page.body.index(second)
  expect(first_pos).not_to be_nil, "\"#{first}\" não aparece na página"
  expect(second_pos).not_to be_nil, "\"#{second}\" não aparece na página"
  expect(first_pos).to be < second_pos
end