require 'nokogiri'
require 'open-uri'
require 'uri'

module ThePirateBay
  class Search
    attr_reader :torrents
    alias_method :results, :torrents

    def initialize(query, page = 0, sort_by = 99, category = 0)
      
      query = URI.escape(query)
      doc = Nokogiri::HTML(open('http://thepiratebay.org/search/' + query + '/' + page.to_s + '/' + sort_by.to_s + '/' + category.to_s + ''))
      torrents = []
      nbsp = Nokogiri::HTML("&nbsp;").text

      doc.css('#searchResult tr').each do |row|
        title = row.search('.detLink').text
        next if title == ''

        seeders     = row.search('td')[2].text.to_i
        leechers    = row.search('td')[3].text.to_i
        magnet_link = row.search('td a')[3]['href']
        category    = row.search('td a')[0].text
        url         = row.search('.detLink').attribute('href').to_s
        torrent_id  = url.split('/')[2]
        uploader    = row.search('.detDesc > a').text

        match_sub   = /^Uploaded (.*?), Size (.*?), ULed by/.match(row.search('font.detDesc').text)
        
        upload_date = if match_sub[1] == "Today"
          DateTime.now.to_date
        elsif match_sub[1] == "Y-Day"
          Date.yesterday.to_date
        elsif match_sub[1].split(nbsp)[1].include? ":" # has a timestamp, is this year
          date = match_sub[1].split(nbsp)[0]
          Date.parse("#{date} #{DateTime.now.year}").to_date
        else
          Date.parse(match_sub[1]).to_date
        end

        size        = match_sub[2]
        is_vip      = (row.search('img[alt="VIP"]').length > 0)
        is_trusted  = (row.search('img[alt="Trusted"]').length > 0)

        torrent = {:title       => title,
                   :seeders     => seeders,
                   :leechers    => leechers,
                   :magnet_link => magnet_link,
                   :category    => category,
                   :torrent_id  => torrent_id,
                   :url         => url,
                   :uploader    => uploader,
                   :upload_date => upload_date,
                   :size        => size,
                   :is_vip      => is_vip,
                   :is_trusted  => is_trusted}

        torrents.push(torrent)
      end

      @torrents = torrents
    end
  end
end
