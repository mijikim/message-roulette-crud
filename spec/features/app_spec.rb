require "rspec"
require "capybara"

feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "As a user, I can delete a message" do
    visit "/"
    fill_in "Message", :with => "Testing testing"
    click_button "Submit"
    expect(page).to have_content("Testing testing")
    click_button "Delete"
    expect(page).to have_no_content("Testing testing")
  end

  scenario "As a user, I can add comment to a message" do
    visit "/"
    fill_in "Message", :with => "Testing testing"
    click_button "Submit"
    expect(page).to have_content("Testing testing")
    fill_in "comment", :with => "Good job!"
    click_button "Add Comment"
    expect(page).to have_content("Good job!")
  end
end
