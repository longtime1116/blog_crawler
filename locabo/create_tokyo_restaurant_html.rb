require "csv"

def build_comments(comments_str)
  li = comments_str.map do |comment_str|
    "<li>#{comment_str}</li>"
  end.join

  "<ul>#{li}</ul>"
end

outfile = File.open("./locabo_tokyo_restaurant.html", "w")
outfile.puts(File.read("./txt/tokyo_header.txt"))

regions = []
# csv parse
# 想定する headers は ["営業状況", "店名", "ジャンル", "最寄り駅", "地域", "コメント", "URL"]
region_restaurants_hash = {}
CSV.foreach("./locabo.csv", headers: true) do |f|
  next if f["地域"].nil?
  unless region_restaurants_hash.keys.include?(f["地域"])
    region_restaurants_hash[f["地域"]] = []
  end

  region_restaurants_hash[f["地域"]] << {
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
region_restaurants_hash.each do |region, restaurants|

  region = "&nbsp;<h2>#{region}</h2>"
  outfile.puts(region)

  restaurants.each do |restaurant|
    need_delete = !restaurant[:open]
    title = "<a href=\"#{restaurant[:url]}\">#{restaurant[:name]}</a>(#{restaurant[:genre]})"
    title = "<del>#{title}</del>" if need_delete
    station_str = if restaurant[:station].nil?
                    nil
                  else
                    "#{restaurant[:station]}駅より#{restaurant[:walk]}"
                  end
    comments = build_comments([station_str, restaurant[:comments]].flatten.compact)

    outfile.puts(title)
    outfile.puts(comments)
  end
end
