# This file should ensure the existence of records required to run the application
# in every environment (production, development, test). The code here should be
# idempotent so that it can be executed at any point in every environment.

user = User.first || User.create!(
  name: "テスト",
  nickname: "テストくん",
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)

seeds_dir = Rails.root.join("db/seeds")

places = [
  {
    file: "midori_park.png",
    attrs: {
      name: "みどり公園",
      description: "広い芝生の公園",
      prefecture: "東京都",
      city: "渋谷区",
      address: "1-1",
      category: :park,
      indoor_outdoor: :outdoor,
      min_age: 0,
      max_age: 12,
      adult_price: 0,
      child_price: 0
    }
  },
  {
    file: "kids_park.png",
    attrs: {
      name: "キッズパーク",
      description: "室内の遊び場",
      prefecture: "東京都",
      city: "新宿区",
      address: "2-2",
      category: :indoor_facility,
      indoor_outdoor: :indoor,
      min_age: 1,
      max_age: 6,
      adult_price: 500,
      child_price: 300,
      opening_time: "9:00",
      closing_time: "18:00"
    }
  },
  {
    file: "kagaku_mirai.png",
    attrs: {
      name: "科学未来館",
      description: "科学を体験できる施設",
      prefecture: "東京都",
      city: "江東区",
      address: "3-3",
      category: :museum,
      indoor_outdoor: :indoor,
      min_age: 5,
      max_age: 15,
      adult_price: 600,
      child_price: 400,
      opening_time: "10:00",
      closing_time: "17:00"
    }
  }
]

places.each do |seed|
  place = user.places.build(seed[:attrs])
  place.cover_image.attach(
    io: File.open(seeds_dir.join(seed[:file])),
    filename: seed[:file],
    content_type: "image/png"
  )
  place.save!
end

puts "作成完了: #{Place.count}件"
