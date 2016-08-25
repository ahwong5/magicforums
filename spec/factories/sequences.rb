FactoryGirl.define do
  sequence :title do |n|
    "New Topic Title-#{n}"
  end

  sequence :description do |n|
    "New Topic Description-#{n}"
  end

  sequence :body do |n|
    "super-duper super-duper super duper super duper duper long long lon glong long super-heavy-body-#{n}"
  end
end
