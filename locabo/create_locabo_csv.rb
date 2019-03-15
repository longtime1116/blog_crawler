require "csv"

outfile = CSV.open("./locabo_restaurant.csv", "w")
outfile << ["店名", "ジャンル", "URL"]
File.open("./sample.html") do |file|
  file.each_line do |line|
    url_match = line.match(/(http.*?)\">/)
    next if url_match.nil?
    name_match = line.match(/\">(.*)<\/a>/)
    genre_match = line.match(/>\((.*)\)<\/p>/)

    url = url_match[1] unless url_match.nil?
    name = name_match[1] unless name_match.nil?
    genre = genre_match[1] unless genre_match.nil?

    outfile << [name, genre, url]
  end
end
