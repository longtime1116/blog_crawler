require "csv"
require "pp"

def build_comments(comments_str)
  li = comments_str.map do |comment_str|
    "<li>#{comment_str}</li>"
  end.join

  "<ul>#{li}</ul>"
end

outfile = File.open("./locabo_shinjuku_restaurant.html", "w")
outfile.puts(File.read("./txt/shinjuku_header.txt"))

# csv parse
station_restaurants_hash = {}
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

# output html from parsed data
station_restaurants_hash.each do |station, restaurants|
  next unless station.include?("新宿")
  h2_station = "&nbsp;<h2>#{station}駅</h2>"
  outfile.puts(h2_station)
  restaurants.each do |restaurant|
    need_delete = !restaurant[:open]
    title = "<a href=\"#{restaurant[:url]}\">#{restaurant[:name]}</a>(#{restaurant[:genre]})"
    title = "<del>#{title}</del>" if need_delete
    comments = build_comments(["#{station}駅より#{restaurant[:walk]}", restaurant[:comments]].flatten)

    outfile.puts(title)
    outfile.puts(comments)
  end
end
