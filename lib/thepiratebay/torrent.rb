require 'nokogiri'
require 'open-uri'

module ThePirateBay
  class Torrent
    def self.find(torrent_id)

      doc = Nokogiri::HTML(open('https://thepiratebay.org/torrent/' + torrent_id.to_s))

      dd_cache = contents.search('#details dd').select{|dd| is_a_number?(dd.text) }

      contents    = doc.search('#detailsframe')
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
