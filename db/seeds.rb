# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.first || User.create!(name: "テスト", email: "test@example.com", password: "password123", password_confirmation: "password123")

user.places.create!(name: "みどり公園", description: "広い芝生の公園", address: "東京都渋谷区1-1", category: :park, indoor_outdoor: :outdoor, min_age: 0, max_age: 12, adult_price: 0, child_price: 0)
user.places.create!(name: "キッズパーク", description: "室内の遊び場", address: "東京都新宿区2-2", category: :indoor_facility, indoor_outdoor: :indoor, min_age: 1, max_age: 6, adult_price: 500, child_price: 300, opening_time: "9:00", closing_time: "18:00")
user.places.create!(name: "科学未来館", description: "科学を体験できる施設", address: "東京都江東区3-3", category: :museum, indoor_outdoor: :indoor, min_age: 5, max_age: 15, adult_price: 600, child_price: 400, opening_time: "10:00", closing_time: "17:00")
puts "作成完了: #{Place.count}件"
