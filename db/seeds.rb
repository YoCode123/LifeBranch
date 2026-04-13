# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Category.create(name: "仕事")
Category.create(name: "恋愛")
Category.create(name: "お金")
EmotionType.create!(name: "嬉しい")
EmotionType.create!(name: "不安")
EmotionType.create!(name: "後悔")
EmotionType.create!(name: "ワクワク")
EmotionType.create!(name: "安心")
