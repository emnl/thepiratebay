require 'nokogiri'
require 'open-uri'

module ThePirateBay
  class Torrent
    PROCESS = Hash.new(->(e){ e.text.gsub(/\n|\t|\s$|^\s/, '') })
    .merge(
      files: ->(e){ e.text.to_i },
      size: ->(e){ e.text.scan(/\d+/)[-1].to_i },
      info: ->(e){ e.at('a')[:href] },
      spoken_languages: ->(e){ e.text.split(', ') },
      texted_languages: ->(e){ e.text.split(', ') },
      tags: ->(e){ e.search('a').map(&:text) },
      uploaded: ->(e){ Time.gm *e.text.scan(/\d+/).reject(&:empty?).map(&:to_i) },
      seeders: ->(e){ e.text.to_i },
      leechers: ->(e){ e.text.to_i },
      comments: ->(e){ e.text.to_i }
    )

    def self.find(torrent_id)
      url = "http://thepiratebay.org/torrent/#{torrent_id.to_s}"
      doc = Nokogiri::HTML(open(url))
      keys = doc.search('dt').map do |key| 
        key.text.downcase
        .gsub(/:$/, '')
        .gsub(/\(s\)/, 's')
        .gsub(/\s/, '_')
        .to_sym 
      end
      values = doc.search('dd')
      attr_hash = Hash[key.zip(values)]
      .inject({}) { |h,(k,v)| h[k] = PROCESS[k].call(v); h }
      .merge(
        title: doc.at('#title').text.gsub(/\n|\t|\s$|^\s/, ''),
        torrent_link: url,
        magnet_link: doc.at('.download a')[:href],
        info_hash: doc.at('dl').children.last.text.gsub(/\n|\t|\s$|^\s/, '')
      )
    end
  end
end