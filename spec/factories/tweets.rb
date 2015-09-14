FactoryGirl.define do
  factory :tweet do
    sequence(:twitter_id)  {|n| n }
    sequence(:text)   { |n| "string#{n}" }
    sequence(:image_url)   { |n| "http://foo.bar/img.jpg#{n}" }
    link              "http://foo.bar"
    author_image_url  "http://foo.bar/img.jpg"
    language          "en"
    tweeted_at        Date.parse("10/10/2010")
    username          "foo"
  end
end