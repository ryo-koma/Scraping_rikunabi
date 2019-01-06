require 'open-uri'
require 'nokogiri'
require 'csv'
require 'byebug'

namespace :company do
  desc '会社情報を抽出する'
  task fetch: :environment do
    puts("Process Start")
    exec
    puts("Process Finished")
  end

  def fetch_data(documents, companies)
    content_xpath = "//a[@class='ts-h-search-cassetteTitleMain js-h-search-cassetteTitleMain']"
    documents.xpath(content_xpath).each do |n|
      companies << n.text.strip
    end
  end

  def exec
    puts "What is the maximum page? "
    page = STDIN.gets.to_i

    companies = []
    1.upto page do |index|
      uri = "https://job.rikunabi.com/2019/s/__13_0_______/?moduleCd=2&isc=ps054&pn=#{index}"
      html = open(uri).read
      documents = Nokogiri::HTML(html)
      fetch_data(documents, companies)
    end

    headers = ["会社名"]
    time = Time.new.strftime("%Y-%m-%d")
    output_dir = Rails.root.join('tmp', "rikunabi_tokyo_2019-#{time}.csv")

    CSV.open(output_dir, "a", headers: headers, write_headers: true) do |csv|
      companies.each do |company|
        csv << [company]
      end
    end
  end
end
