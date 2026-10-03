xml.instruct! :xml, version: "1.0"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc root_url
  end

  @places.each do |place|
    xml.url do
      xml.loc place_url(place)
      xml.lastmod place.updated_at.iso8601
    end
  end

  @users.each do |user|
    xml.url do
      xml.loc user_url(user)
    end
  end
end
