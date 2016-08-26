require 'rails_helper'

RSpec.describe User, type: :model do
  context "assocation" do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should have_many(:topics) }
  end

  context "email validation" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value("user@gmail.com").for(:email) }
    it { should_not allow_value("invalidformat").for(:email) }
  end

  context "username validation" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  context "image size validation" do
    it "should reject image larger than 1mb" do
      user = create(:user)
      user.update(image: fixture_file_upload("#{::Rails.root}/spec/fixtures/bigcat.jpeg"))

      expect(user.errors.full_messages[0]).to eql("File size is too big. Please make sure it is 1MB or smaller.")
    end

    it "should allow image smaller than 1mb" do
      user = create(:user)
      user.update(image: fixture_file_upload("#{::Rails.root}/spec/fixtures/cat.jpg"))

      expect(user.image).to be_present
      expect(user.image.file.size).to be <= 1.megabyte
    end
  end

  context "slug callback" do
    it "should set slug" do
      user = create(:user)

      expect(user.slug).to eql(user.username.gsub(" ", "-"))
    end

    it "should update slug" do
      user = create(:user)

      user.update(username: "updatedname")

      expect(user.slug).to eql("updatedname")
    end
  end
end
