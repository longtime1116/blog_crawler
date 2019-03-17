require "csv"

def build_comments(comments_str)
  li = comments_str.split("・").map do |comment_str|
    "<li>#{comment_str}</li>"
  end.join

  "<ul>#{li}</ul>"
end

outfile = File.open("./locabo_tokyo_restaurant.html", "w")
outfile.puts(File.read("./txt/tokyo_header.txt"))

regions = []
# 想定する headers は ["営業状況", "店名", "ジャンル", "最寄り駅", "地域", "コメント", "URL"]
CSV.foreach("./locabo.csv", headers: true) do |f|
  unless regions.include?(f["地域"])
    regions << f["地域"]
    region = "&nbsp;<h2>#{f["地域"]}</h2>"
  end

  need_delete = f["営業状況"] == "x"
  title = "<a href=\"#{f["URL"]}\">#{f["店名"]}</a>(#{f["ジャンル"]})"
  title = "<del>#{title}</del>" if need_delete

  comments = build_comments(f["コメント"])

  outfile.puts(region) if region
  outfile.puts(title)
  outfile.puts(comments)
end
