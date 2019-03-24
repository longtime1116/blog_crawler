require "csv"
require_relative "common"

outfile = File.open("./output/locabo_tokyo_restaurant.html", "w")
outfile.puts(File.read("./input/txt/tokyo_header.txt"))

# csv parse
region_restaurants_hash = build_region_restaurants_hash_from("./input/locabo.csv")

# output html from parsed data
region_restaurants_hash.each do |region, restaurants|
  outfile.puts(build_h2(region))

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
outfile.puts(File.read("./input/txt/tokyo_footer.txt"))
outfile.close
