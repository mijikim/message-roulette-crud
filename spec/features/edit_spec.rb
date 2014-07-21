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


  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    click_link "Edit"
    fill_in 'message_edited', :with => "Yo" * 140
    click_button "Edit Message"
    save_and_open_page
    expect(page).to have_content("Message must be less than 140 characters.")

  end

end