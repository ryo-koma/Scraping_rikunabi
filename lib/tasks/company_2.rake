require 'open-uri'
require 'nokogiri'
require 'csv'
require 'byebug'
require 'kconv'

namespace :company_2 do
  def get_data(uri, data)
    companies = data[0]
    parameters = data[1]
    html = open(uri).read
    documents = Nokogiri::HTML(html.toutf8, nil, 'utf-8')
    #byebug
    companies << documents.xpath("//h1[@class='ts-h-company-mainTitle']").text
    #byebug
    parameters << documents.xpath("//div[@class='ts-h-company-sentence']")[1].text.strip.gsub(/(\r)/, " ")
    return [companies, parameters]
  end

  def main()
    uri = "https://job.rikunabi.com/2019/company/r294900083/"
    puts "What is the maximum page? "
    page = gets.to_i

    companies = []
    parameters = []
    data = [companies, parameters]
    data = get_data(uri,data)
    (2..page).to_a.each do |idx|
      uri = "https://job.rikunabi.com/2019/company/r294900083/"
      data = get_data(uri,data)
    end

    len = [companies.size,parameters.size].min - 1

    headers = ["会社名","Email"]
    time = Time.new.strftime("%Y-%m-%d")
    CSV.open("rikunabi_tokyo_2019-#{time}.csv", "a",headers: headers, write_headers: true) do |csv|
      (0..len).to_a.each do |idx|
        csv_column_values = [companies[idx], parameters[idx]]
        csv << csv_column_values
      end
    end
  end

  if __FILE__ == $0
    puts("Process Start")
    main()
    puts("Process Finished")
  end
end
