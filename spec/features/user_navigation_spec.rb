require "rails_helper"

RSpec.feature "User Navigation", type: :feature do

  before(:all) do
    @user = create(:user)
    @topic = create(:topic)
    @post = create(:post, topic_id: @topic.id, user_id: @user.id)
    @comment = create(:comment, post_id: @post.id, user_id: @user.id)
  end

  scenario "User visits landing page" do
    visit root_path
    expect(page).to have_current_path(root_path)
    # expect(page).to have_css('.landing.index')
  end

  scenario "User clicks landing page topics" do
    # visit new_session_path
    # fill_in 'Email', with: "#{@user.email}"
    # fill_in 'Password', with: 'password'
    # click_button("Log me in!")

    click_link("topics-index")

    expect(page).to have_current_path(topics_path)
    expect(page).to have_css('.topics.index')
  end

  # scenario "User clicks home" do
  #   visit new_user_path
  #   click_link("Home")
  #
  #   expect(page).to have_current_path(root_path)
  #   expect(page).to have_css('.landing.index')
  # end
  #
  # scenario "User clicks join us" do
  #   visit "/"
  #   click_link("join-us")
  #
  #   expect(page).to have_current_path(new_user_path)
  #   expect(page).to have_css('.users.new')
  # end
  #
  # scenario "User clicks do not have account" do
  #   visit new_session_path
  #   click_link("I don't have an account yet")
  #
  #   expect(page).to have_current_path(new_user_path)
  #   expect(page).to have_css('.users.new')
  # end
  #
  # scenario "User clicks already have account" do
  #   visit new_user_path
  #   click_link("I already have an account")
  #
  #   expect(page).to have_current_path(new_session_path)
  #   expect(page).to have_css('.sessions.new')
  # end
  #
  # scenario "User clicks forgot passwod" do
  #   visit new_session_path
  #   click_link("I forgot my password")
  #
  #   expect(page).to have_current_path(new_password_reset_path)
  #   expect(page).to have_css('.password-resets.new')
  # end
  #
  # scenario "User clicks topics" do
  #   visit root_path
  #   click_link("Topics")
  #
  #   expect(page).to have_current_path(topics_path)
  #   expect(page).to have_css('.topics.index')
  # end
  #
  # scenario "User clicks topic" do
  #   visit topics_path
  #   click_link(@topic.title)
  #
  #   expect(page).to have_current_path(topic_posts_path(@topic))
  #   expect(page).to have_css('.posts.index')
  # end
  #
  # scenario "User clicks post" do
  #   visit topic_posts_path(@topic)
  #   click_link(@post.title)
  #
  #   expect(page).to have_current_path(topic_post_comments_path(@topic, @post))
  #   expect(page).to have_css('.comments.index')
  # end
end
