require 'nokogiri'
require 'open-uri'
require 'uri'
require 'socksify/http'

module ThePirateBay
  class Search
    attr_reader :torrents
    alias_method :results, :torrents

    def initialize(query, page = 0, sort_by = 99, category = 0, tor = false)

      query = URI.escape(query)
      request_url = 'http://thepiratebay.org/search/' + query + '/' + page.to_s + '/' + sort_by.to_s + '/' + category.to_s + ''
      if tor
        tor = '127.0.0.1:9050' if tor == true
        uri = URI.parse(request_url)
        host = tor.split(':').first
        port = tor.split(':').last.to_i
        Net::HTTP.SOCKSProxy(host, port).start(uri.host, uri.port) do |http|
          doc = http.get(uri.path)
        end
      else
        doc = Nokogiri::HTML(open(request_url))
      end
      torrents = []

      doc.css('#searchResult tr').each do |row|
        title = row.search('.detLink').text
        next if title == ''

        seeders     = row.search('td')[2].text.to_i
        leechers    = row.search('td')[3].text.to_i
        magnet_link = row.search('td a')[3]['href']
        category    = row.search('td a')[0].text
        url         = row.search('.detLink').attribute('href').to_s
        torrent_id  = url.split('/')[2]

        torrent = {:title       => title,
                   :seeders     => seeders,
                   :leechers    => leechers,
                   :magnet_link => magnet_link,
                   :category    => category,
                   :torrent_id  => torrent_id,
                   :url         => url}

        torrents.push(torrent)
      end

      @torrents = torrents
    end
  end
end
