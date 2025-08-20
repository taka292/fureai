module MentalConditionsHelper
  def mental_state_icon(state)
    case state
    when "very_bad"
      "favorite"  # 1個のハート
    when "bad"
      "favorite_border"  # 2個のハート
    when "normal"
      "favorite"  # 3個のハート
    when "good"
      "favorite"  # 4個のハート
    when "very_good"
      "favorite"  # 5個のハート
    end
  end

  def physical_state_icon(state)
    case state
    when "very_bad"
      "sentiment_very_dissatisfied"  # とても不満
    when "bad"
      "sentiment_dissatisfied"  # 不満
    when "normal"
      "sentiment_neutral"  # 普通
    when "good"
      "sentiment_satisfied"  # 満足
    when "very_good"
      "sentiment_very_satisfied"  # とても満足
    end
  end

  def mental_state_icons(state)
    count = case state
    when "very_bad" then 1
    when "bad" then 2
    when "normal" then 3
    when "good" then 4
    when "very_good" then 5
    end
    (1..5).map do |i|
      icon_class = i <= count ? "text-red-500" : "text-gray-300"
      content_tag(:span, "favorite", class: "material-symbols-outlined #{icon_class} text-2xl mr-0.5")
    end.join.html_safe
  end

  def physical_state_icons(state)
    count = case state
    when "very_bad" then 1
    when "bad" then 2
    when "normal" then 3
    when "good" then 4
    when "very_good" then 5
    end
    (1..5).map do |i|
      icon_class = i <= count ? "text-orange-400" : "text-gray-300"
      content_tag(:span, "sentiment_satisfied", class: "material-symbols-outlined #{icon_class} text-2xl mr-0.5")
    end.join.html_safe
  end

  def mental_state_to_number(state)
    case state
    when "very_bad" then 1
    when "bad" then 2
    when "normal" then 3
    when "good" then 4
    when "very_good" then 5
    else 0
    end
  end

  def physical_state_to_number(state)
    case state
    when "very_bad" then 1
    when "bad" then 2
    when "normal" then 3
    when "good" then 4
    when "very_good" then 5
    else 0
    end
  end
end
