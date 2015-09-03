FactoryGirl.define do
  factory :user do
    sequence(:email)  {|n| "string#{n}@example.com" }
    name              "string"
    avatar            "string"
    language          "en"

    factory :user_with_authentication do
      after(:create) do |user|
        FactoryGirl.create(:authentication_provider, user: user)
      end
    end
  end
end