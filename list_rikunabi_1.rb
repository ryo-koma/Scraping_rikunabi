require 'open-uri'
require 'nokogiri'
require 'csv'
require 'byebug'

def get_data(uri, companies)
  html = open(uri).read
  documents = Nokogiri::HTML(html)
  #byebug
  documents.xpath("//a[@class='ts-h-search-cassetteTitleMain js-h-search-cassetteTitleMain']").each {|n| companies << n.text.strip}
  return companies
end

def main()
  uri = "https://job.rikunabi.com/2019/s/__13_0_______/"
  puts "What is the maximum page? "
  page = gets.to_i

  companies = []
  data = get_data(uri,companies)
  (2..page).to_a.each do |idx|
    uri = "https://job.rikunabi.com/2019/s/__13_0_______/?moduleCd=2&isc=ps054&pn=#{idx}"
    data = get_data(uri,companies)
  end

  len = [companies.size].min - 1

  headers = ["会社名"]
  time = Time.new.strftime("%Y-%m-%d")
  CSV.open("rikunabi_tokyo_2019-#{time}.csv", "a",headers: headers, write_headers: true) do |csv|
    (0..len).to_a.each do |idx|
      csv_column_values = [companies[idx]]
      csv << csv_column_values
    end
  end
end

if __FILE__ == $0
  puts("Process Start")
  main()
  puts("Process Finished")
end
