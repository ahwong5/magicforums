FactoryGirl.define do
  factory :topic do
    title "Topic Topic Topic Topic"
    description "Topic Description Topic Description Topic Description Topic Description Topic Description"
    user_id { create(:user, :admin).id }

    trait :sequenced_title do
      title
    end

    trait :sequenced_description do
      description
    end
  end
end
