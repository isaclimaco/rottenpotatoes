Given(/^I am on (.+)$/) do |page_name|
  visit(path_to(page_name))
end

Then(/^I should be on (.+)$/) do |page_name|
  expect(current_path).to eq(path_to(page_name))
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

When('I fill in {string} with {string}') do |field, value|
  fill_in(field, with: value)
end

When('I press {string}') do |button|
  click_button(button)
end

When('I follow {string}') do |link|
  click_link(link)
end

When('I select {string} from {string}') do |option, field|
  select(option, from: field)
end

Then('I should see {string} before {string}') do |first, second|
  # 1. descobrir a posição de first no page.body
  first_position = page.body.index(first)

  # 2. descobrir a posição de second no page.body
  second_position = page.body.index(second)

  # conferir que os dois textos existem na página
  expect(first_position).not_to be_nil, "\"#{first}\" não aparece na página"
  expect(second_position).not_to be_nil, "\"#{second}\" não aparece na página"

  # 3. verificar que a primeira posição é menor que a segunda
  expect(first_position).to be < second_position
end