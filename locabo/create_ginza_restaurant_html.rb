require "csv"
require "pp"
require_relative "common"

outfile = File.open("./output/locabo_ginza_restaurant.html", "w")
outfile.puts(File.read("./input/txt/ginza_header.txt"))

# csv parse
station_restaurants_hash = build_station_restaurants_hash_from("./input/locabo.csv")

# output html from parsed data
station_restaurants_hash.each do |station, restaurants|
  next unless ["銀座", "日比谷", "有楽町", "東京"].any? { |str| station.include?(str) }
  outfile.puts(build_h2("#{station}駅"))

  restaurants.each do |restaurant|
    title = build_title(url: restaurant[:url],
                        name: restaurant[:name],
                        genre: restaurant[:genre],
                        need_delete: !restaurant[:open])
    comments = build_comments(station: restaurant[:station],
                              walk: restaurant[:walk],
                              comments: restaurant[:comments])
    outfile.puts(title)
    outfile.puts(comments)
  end
end
outfile.close
