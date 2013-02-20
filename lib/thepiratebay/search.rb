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

      doc.css('#searchResult tr').each do |row|
        title = row.search('.detLink').text
        next if title == ''
        torrents << {
          title: title,
          seeders: row.search('td')[2].text.to_i,
          leechers: row.search('td')[3].text.to_i,
          torrent_link: row.search('td a')[2]['href'],
          magnet_link: row.search('td a')[3]['href'],
          category: row.search('td a')[0].text,
          torrent_id: row.search('td a')[2]['href'].scan(/\d+/)[0]
        }
      end

      @torrents = torrents
    end
  end
end
