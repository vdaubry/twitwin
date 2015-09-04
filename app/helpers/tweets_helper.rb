module TweetsHelper
  def play_link(tweet, played)
    if current_user
      if played.include? tweet
        link_to "Already played", "#", class: "btn btn-danger btn-play"
      else
        link_to "Click to play !", tweet_participation_index_path(tweet.id), class: "btn btn-success btn-play activated", remote: true, method: :post
      end
    else
      link_to "Connect to twitter to play !", "auth/twitter", :onclick => "$(\"#modal-window\").modal('show')", class: "btn btn-success btn-play"
    end
  end

  def tweet_image(tweet)
    if tweet.image_url
      image_tag tweet.image_url, class: "img-responsive"
    else
      content_tag(:i, "", class: "fa fa-gift gift")
    end
  end
end