FactoryGirl.define do
  factory :tweet do
    sequence(:tweet_id)  {|n| n }
    text              "string"
    image_url         "http://foo.bar/img.jpg"
    link              "http://foo.bar"
    author_image_url  "http://foo.bar/img.jpg"
  end
end