require "rspec"
require "capybara"

feature "Edit Message" do
  scenario "As a user, I can edit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    click_link "Edit"
    fill_in 'message_edited', :with => "Yo"
    click_button "Edit Message"
    expect(page).to have_content("Yo")
  end
end