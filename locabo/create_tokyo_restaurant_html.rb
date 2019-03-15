require "csv"

def build_comments(comments_str)
  li = comments_str.split("・").map do |comment_str|
    "<li>#{comment_str}</li>"
  end.join

  "<ul>#{li}</ul>"
end

outfile = File.open("./locabo_tokyo_restaurant.html", "w")
outfile.puts(File.read("./header.txt"))

regions = []
# 想定する headers は ["営業状況", "店名", "ジャンル", "最寄り駅", "地域", "コメント", "URL"]
CSV.foreach("./locabo.csv", headers: true) do |f|
  unless regions.include?(f[4])
    regions << f[4]
    region = "&nbsp;<h2>#{f[4]}</h2>"
  end

  need_delete = f[0] == "x"
  title = "<a href=\"#{f[6]}\">#{f[1]}</a>(#{f[2]})"
  title = "<del>#{title}</del>" if need_delete

  comments = build_comments(f[5])

  outfile.puts(region) if region
  outfile.puts(title)
  outfile.puts(comments)
end
