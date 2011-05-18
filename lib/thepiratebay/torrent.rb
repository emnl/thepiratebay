require 'nokogiri'
require 'open-uri'

module ThePirateBay
  class Torrent
    def self.find(torrent_id)

      doc = Nokogiri::HTML(open('http://thepiratebay.org/torrent/' + torrent_id.to_s))

      contents = doc.search('#detailsframe')
      title = contents.search('#title').text.strip
      category = contents.search('#details .col1 dd')[0].text
      nr_files = contents.search('#details .col1 dd')[1].text.to_i
      size = contents.search('#details .col1 dd')[2].text
      uploaded = contents.search('#details .col2 dd')[1].text
      seeders = contents.search('#details .col2 dd')[3].text.to_i
      leechers = contents.search('#details .col2 dd')[4].text.to_i
      torrent_link = contents.search('#details .download a')[0]['href']
      magnet_link = contents.search('#details .download a')[1]['href']
      description = contents.search('#details .nfo pre').text

      torrent = {:title => title,
                 :category => category,
                 :files => nr_files, :size => size,
                 :uploaded => uploaded,
                 :seeders => seeders,
                 :leechers => leechers,
                 :torrent_link => torrent_link,
                 :magnet_link => magnet_link,
                 :description => description}

      return torrent
    end
  end
end
