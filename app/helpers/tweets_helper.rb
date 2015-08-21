module TweetsHelper
  def play_link
    if current_user
      link_to "Click to play !", tweet_participation_index_path(tweet.id), class: "btn btn-success btn-play", remote: true, method: :post
    else
      link_to "Click to play !", root_path, class: "btn btn-success btn-play"
    end
  end
end