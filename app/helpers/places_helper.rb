module PlacesHelper
  # 一覧カードの状態マーク用アイコン。
  # kind: :favorite（中までピンクで塗りつぶしたハート）
  def place_status_icon(kind)
    case kind
    when :favorite
      %(<svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor" aria-hidden="true"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 1 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"/></svg>).html_safe
    end
  end

  def place_map_embed_url(place)
    return if ENV["GOOGLE_MAPS_API_KEY"].blank?

    query = {
      key: ENV["GOOGLE_MAPS_API_KEY"],
      q: place.address,
      language: "ja",
      region: "JP"
    }
    "https://www.google.com/maps/embed/v1/place?#{query.to_query}"
  end
end
