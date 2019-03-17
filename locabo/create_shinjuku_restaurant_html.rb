require "csv"
require "pp"

outfile = File.open("./locabo_shinjuku_restaurant.html", "w")
outfile.puts(File.read("./txt/shinjuku_header.txt"))

station_restaurants_hash ={}
CSV.foreach("./locabo.csv", headers: true) do |f|
  next if f["最寄り駅"].nil?
  unless station_restaurants_hash.keys.include?(f["最寄り駅"])
    station_restaurants_hash[f["最寄り駅"]] = []
  end

  station_restaurants_hash[f["最寄り駅"]] << {
    open: f["営業状況"] == "o",
    name: f["店名"],
    genre: f["ジャンル"],
    station: f["最寄り駅"],
    walk: f["徒歩何分"],
    region: f["地域"],
    comments: f["コメント"].split("・"),
    url: f["URL"]
  }
end

station_restaurants_hash.each do |station, restaurants|
  p station
  restaurants.each do |restaurant|
    pp restaurant
  end
end
