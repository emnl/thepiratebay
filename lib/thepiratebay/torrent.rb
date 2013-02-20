require 'nokogiri'
require 'open-uri'

module ThePirateBay
  class Torrent
    PROCESS = Hash.new(->(e){ e.text.gsub(/\n|\t|\s$|^\s/, '') }).merge({
      files: ->(e){ e.text.to_i },
      size: ->(e){ e.text.scan(/\d+/)[-1].to_i },
      info: ->(e){ e.at('a')[:href] },
      spoken_languages: ->(e){ e.text.split(', ') },
      tags: ->(e){ e.search('a').map(&:text) },
      uploaded: ->(e){ Time.gm *e.text.scan(/\d+/).reject(&:empty?).map(&:to_i) },
      seeders: ->(e){ e.text.to_i },
      leechers: ->(e){ e.text.to_i },
      comments: ->(e){ e.text.to_i }
    })

    def self.find(torrent_id)
      doc = Nokogiri::HTML(open('http://thepiratebay.org/torrent/' + torrent_id.to_s))
      keys = doc.search('dt').map { |key| key.text.gsub(/:$/, '').gsub(/\(s\)/, 's').gsub(/\s/, '_').downcase.to_sym }
      values = doc.search('dd')
      attr_hash = Hash[Array.new(keys.size) { |n| [keys[n], values[n]] }].merge({ 
        title: doc.at('#title'),
        info_hash: doc.at('dl').children.last
      })
      hash = {}
      attr_hash.each { |k,v| hash[k] = PROCESS[k].call(v) }
      hash
    end
  end
end
