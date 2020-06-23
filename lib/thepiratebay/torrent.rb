require 'nokogiri'
require 'open-uri'
require 'socksify/http'

module ThePirateBay
  class Torrent
    def self.find(torrent_id, tor = false)

      request_url = 'http://thepiratebay.se/torrent/' + torrent_id.to_s
      if tor
        tor = '127.0.0.1:9050' if tor == true
        uri = URI.parse(request_url)
        host = tor.split(':').first
        port = tor.split(':').last.to_i
        request = Net::HTTP.SOCKSProxy(host, port).start(uri.host, uri.port) do |http|
          http.get(uri.path)
        end
        doc = Nokogiri::HTML(request.body)
      else
        doc = Nokogiri::HTML(open(request_url))
      end

      contents    = doc.search('#detailsframe')

      dd_cache = contents.search('#details dd').select{|dd| is_a_number?(dd.text) }

      title       = contents.search('#title').text.strip
      category    = contents.search('#details .col1 dd')[0].text
      nr_files    = dd_cache[0].text
      size        = contents.search('#details .col1 dd')[2].text
      uploaded    = contents.search('#details dd').select{|dd| dd.text.include?("GMT") }[0].text
      seeders     = dd_cache[1].text
      leechers    = dd_cache[2].text
      magnet_link = contents.search('#details .download a')[1]['href']
      description = contents.search('#details .nfo pre').text
      url         = 'http://thepiratebay.org/torrent/' + torrent_id.to_s

      torrent = {:title       => title,
                 :category    => category,
                 :files       => nr_files, 
                 :size        => size,
                 :uploaded    => uploaded,
                 :seeders     => seeders,
                 :leechers    => leechers,
                 :magnet_link => magnet_link,
                 :description => description,
                 :url         => url}

      return torrent
    end

    def self.is_a_number?(s)
      s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
    end
  end
end
