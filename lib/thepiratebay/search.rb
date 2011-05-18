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
        seeders = row.search('td')[2].text.to_i
        leechers = row.search('td')[3].text.to_i
        torrent_link = row.search('td a')[3]['href']
        magnet_link = row.search('td a')[4]['href']
        category = row.search('td a')[0].text
        torrent_id = torrent_link.scan(/\d+/)[0]

        torrent = {:title => title,
                   :seeders => seeders,
                   :leechers => leechers,
                   :torrent_link => torrent_link,
                   :magnet_link => magnet_link,
                   :category => category,
                   :torrent_id => torrent_id}

        torrents.push(torrent)
      end

      @torrents = torrents
    end
  end
end
