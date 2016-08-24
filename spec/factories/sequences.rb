FactoryGirl.define do
  sequence :title do |n|
    "long title-#{n}"
  end

  sequence :description do |n|
    "very very long long long long long long long long long description of the description of the description description-#{n}"
  end

  sequence :body do |n|
    "super-duper super-duper super duper super duper duper long long lon glong long super-heavy-body-#{n}"
  end
end
