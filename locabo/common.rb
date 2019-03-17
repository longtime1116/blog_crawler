def build_h2(h2_str)
  "&nbsp;<h2>#{h2_str}</h2>" 
end
def build_title(url:, name:, genre:, need_delete:)
  title = "<a href=\"#{url}\">#{name}</a>(#{genre})"
  if need_delete
    title = "<del>#{title}</del>"
  end
  title
end

def build_comments(station:, walk:, comments:)
  station_str = if station.nil?
                  nil
                else
                  "#{station}駅より#{walk}"
                end

  li = [station_str, comments].flatten.compact.map do |comment|
    "<li>#{comment}</li>"
  end.join

  "<ul>#{li}</ul>"
end

# 想定する headers は ["営業状況", "店名", "ジャンル", "最寄り駅", "地域", "コメント", "URL"]
def build_region_restaurants_hash_from(file)
  region_restaurants_hash = {}
  CSV.foreach(file, headers: true) do |f|
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
  region_restaurants_hash
end

def build_station_restaurants_hash_from(file)
  station_restaurants_hash = {}
  CSV.foreach(file, headers: true) do |f|
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
  station_restaurants_hash
end
