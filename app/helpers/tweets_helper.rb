module TweetsHelper
  def play_link(tweet, played)
    if current_user
      if played.include? tweet
        link_to raw("<b>#{t('play_button.played')}</b>"), "#", class: "btn btn-default btn-play"
      else
        link_to(t('play_button.title'), tweet_participation_index_path(tweet.id), remote: true, method: :post, class: "btn btn-success btn-play activated font-bold")
      end
    else
      link_to raw("<b>#{t('play_button.connect')}</b>"), "auth/twitter", :onclick => "$(\"#modal-window\").modal('show')", class: "btn btn-success btn-play"
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