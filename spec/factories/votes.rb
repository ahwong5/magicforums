FactoryGirl.define do
  factory :vote do
    user_id { create(:user, :sequenced_username, :sequenced_email).id }
    comment_id { create(:comment) }

    trait :positive do
      value 1
    end

    trait :negative do
      value -1
    end
  end
end
