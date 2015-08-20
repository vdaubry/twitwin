FactoryGirl.define do
  factory :tweet do
    sequence(:tweet_id)  {|n| n }
    sequence(:text)   { |n| "string#{n}" }
    image_url         "http://foo.bar/img.jpg"
    link              "http://foo.bar"
    author_image_url  "http://foo.bar/img.jpg"
    language          "en"
    tweeted_at        Date.parse("10/10/2010")
  end
end