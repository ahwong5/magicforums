require "rails_helper"

RSpec.feature "User sessions", type: :feature, js: true do
  before(:all) do
    create(:user)
  end

  scenario "User visits logs in page" do

    visit new_session_path
    expect(page).to have_current_path(new_session_path)
  end

  scenario "User logs in" do

    visit root_path
    click_link("Login")
    fill_in 'email', with: 'user@email.com'
    fill_in 'password', with: 'password'
    click_button("Login")

    user = User.find_by(email: "user@email.com")

    expect(page).to have_current_path(root_path)
    expect(find('.flash-messages .message').text).to eql("Welcome back #{user.username}")
  end

  scenario "User logs out" do

    # visit new_session_path
    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: 'password'
    click_button("Login")

    visit root_path
    click_link("Logout")

    expect(page).to have_current_path(root_path)
    expect(find('.flash-messages .message').text).to eql("You've been logged out")
    expect(find_link('Register')).to be_present
    expect(find_link('Login')).to be_present
  end
end
