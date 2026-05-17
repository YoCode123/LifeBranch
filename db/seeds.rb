# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Category.find_or_create_by!(name: "仕事")
Category.find_or_create_by!(name: "恋愛")
Category.find_or_create_by!(name: "人間関係")
Category.find_or_create_by!(name: "お金")
Category.find_or_create_by!(name: "健康")
Category.find_or_create_by!(name: "趣味")
Category.find_or_create_by!(name: "学習")
Category.find_or_create_by!(name: "その他")

EmotionType.find_or_create_by!(name: "嬉しい")
EmotionType.find_or_create_by!(name: "不安")
EmotionType.find_or_create_by!(name: "後悔")
EmotionType.find_or_create_by!(name: "ワクワク")
EmotionType.find_or_create_by!(name: "安心")
EmotionType.find_or_create_by!(name: "緊張")
EmotionType.find_or_create_by!(name: "モヤモヤ")
