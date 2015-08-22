module TweetsHelper
  def play_link(tweet, played)
    if current_user
      if played.include? tweet
        link_to "Already played", "#", class: "btn btn-danger btn-play"
      else
        link_to "Click to play !", tweet_participation_index_path(tweet.id), class: "btn btn-success btn-play", remote: true, method: :post
      end
    else
      link_to "Click to play !", root_path, class: "btn btn-success btn-play"
    end
  end
end