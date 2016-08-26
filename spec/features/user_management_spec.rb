require "rails_helper"

RSpec.feature "User Management", type: :feature do
  before(:all) do
    @user = create(:user)
  end

  scenario "User registers" do

    click_link("Login")
    fill_in 'Username', with: 'ironman'
    fill_in 'Email', with: 'ironman@email.com'
    fill_in 'Password', with: 'password'

    click_button('Sign me up!')

    # user = User.find_by(email: "ironman@email.com")
    #
    # expect(User.count).to eql(2)
    # expect(user).to be_present
    # expect(user.email).to eql("ironman@email.com")
    # expect(user.username).to eql("ironman")
    # expect(find('.flash-messages .message').text).to eql("You're registered, welcome!")
    # expect(page).to have_current_path(root_path)
  end

  # scenario "username registration error" do
  #   visit new_user_path
  #   fill_in 'Username', with: 'bob'
  #   fill_in 'Email', with: 'ironman@email.com'
  #   fill_in 'Password', with: 'password'
  #
  #   click_button('Sign me up!')
  #
  #   expect(User.count).to eql(1)
  #   expect(find('.flash-messages .message').text).to eql("Username has already been taken")
  # end
  #
  # scenario "email registration error" do
  #   visit new_user_path
  #   fill_in 'Username', with: 'user'
  #   fill_in 'Email', with: 'user@email.com'
  #   fill_in 'Password', with: 'password'
  #
  #   click_button('Sign me up!')
  #
  #   expect(User.count).to eql(1)
  #   expect(find('.flash-messages .message').text).to eql("Email has already been taken")
  # end
  #
  # scenario "user redirected if not logged in" do
  #   visit edit_user_path(@user)
  #
  #   expect(find('.flash-messages .message').text).to eql("You need to login first")
  # end
  #
  # scenario "user updates details" do
  #
  #   visit new_session_path
  #   fill_in 'Email', with: 'user@email.com'
  #   fill_in 'Password', with: 'password'
  #   click_button("Log me in!")
  #
  #   visit edit_user_path(@user)
  #   fill_in 'Email', with: 'new@email.com'
  #   fill_in 'Username', with: "newusername"
  #   click_button("Update details!")
  #
  #   expect(find('.flash-messages .message').text).to eql("You've updated your details")
  #   user = User.find_by(email: "new@email.com")
  #
  #   expect(user).to be_present
  #   expect(user.username).to eql("newusername")
  # end
  #
  # scenario "user updates password" do
  #
  #   visit new_session_path
  #   fill_in 'Email', with: 'user@email.com'
  #   fill_in 'Password', with: 'password'
  #   click_button("Log me in!")
  #
  #   visit edit_user_path(@user)
  #   fill_in 'Password', with: "newpassword"
  #   click_button("Update password!")
  #
  #   click_link("Logout")
  #
  #   visit new_session_path
  #   fill_in 'Email', with: 'user@email.com'
  #   fill_in 'Password', with: 'newpassword'
  #   click_button("Log me in!")
  #
  #   user = User.find_by(email: "user@email.com")
  #
  #   expect(page).to have_current_path(root_path)
  #   expect(find('.flash-messages .message').text).to eql("Welcome back #{user.username}")
  # end
end
