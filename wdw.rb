require "mechanize"
require "csv"
require "date"
require "pry"

class WDWBlogCrawler
  def initialize(url)
    @top_url = url
    @agent = Mechanize.new
    @outfname = "./data_#{DateTime.now.strftime("%Y%m%d_%H%M%S")}.csv"
    initialize_csv
  end

  def output_entries()
    url = first_entry_url
    i = 0
    while true
      sleep(1)
      page = @agent.get(url)
      output_entry(url, page)
      url = next_url(page)
      break if url.nil?
    end
  end

  private

  def first_entry_url
    @agent.get(@top_url).search("//*[@id=\"main-inner\"]/div[1]/section[1]/div[1]/h1/a")[0].attributes["href"].value
  end

  def next_url(page)
    target = nil

    cand1 = page.search('//*[@id="main-inner"]/div/span[2]/a')
    if cand1 && !cand1.empty? &&  cand1[0]&.attributes["rel"]&.value == "next"
      target = cand1
    end

    cand2 = page.search('//*[@id="main-inner"]/div/span/a')
    if cand2 && !cand2.empty? && cand2[0]&.attributes["rel"]&.value == "next"
      target = cand2
    end

    return nil if target.nil?
    target[0].attributes["href"].value
  end

  def output_entry(url, page)
    affiliate_links = page.links.select { |link| affiliate_url?(link.href) }
    p url
    CSV.open(@outfname, "a") do |row|
      affiliate_links.each do |link|
        row << [url, page.search("//*/div/header/h1").text.delete("\n"), link.href]
      end
    end
  end

  def initialize_csv
    CSV.open(@outfname, "w") do |row|
      row << ["url", "title", "link"]
    end
  end

  def affiliate_url?(url)
    ["ck.jp.ap.valuecommerce.com",
     "www.klook.com",
     "www.kkday.com",
     "af.moshimo.com",
     "px.a8.net"].any? {|str| url&.include?(str)}
  end

end

crawler = WDWBlogCrawler.new("http://www.yukapiroooon.com/")
crawler.output_entries()
