FactoryGirl.define do
  factory :topic do
    title "New Topic Title"
    description "New Topic Description"
    user_id { create(:user, :admin).id }

    trait :sequenced_title do
      title
    end

    trait :sequenced_description do
      description
    end
  end
end
