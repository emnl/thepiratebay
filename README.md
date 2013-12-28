The ThePirateBay Ruby Gem
====================
A simple interface to ThePirateBay.org

Installation
------------
    gem install thepiratebay


Usage Examples
--------------
    require 'thepiratebay'

    # Search for torrents, returns array
    ThePirateBay::Search.new('query').results

    # Lookup specific torrent with the tpb torrent id
    ThePirateBay::Torrent.find("123123123")

    # Lookup specific torrent with the tpb torrent id via TOR (The Onion Router, by default on 127.0.0.1:9050)
    ThePirateBay::Torrent.find("123123123", true)

    # Lookup specific torrent with the tpb torrent id via TOR (The Onion Router, on custom address)
    ThePirateBay::Torrent.find("123123123", '8.8.8.8:8472')

    # Page, sort and category is optional - (query, page, sort, category)
    # Page 2 is actually page 3, you know the drill
    ThePirateBay::Search.new('query', 2, ThePirateBay::SortBy::Seeders, ThePirateBay::Category::Video).results

    # To add TOR (The Onion Router) support simply add true after all params (by default on 127.0.0.1:8472)
    ThePirateBay::Search.new('query', 2, ThePirateBay::SortBy::Seeders, ThePirateBay::Category::Video, true).results

    # To add TOR (The Onion Router) on custom address/port add this custom address after all params
    ThePirateBay::Search.new('query', 2, ThePirateBay::SortBy::Seeders, ThePirateBay::Category::Video, '8.8.8.8:6969').results

    # The following sortings are available:
    ThePirateBay::SortBy::Relevance   # ThePirateBay-decided relevancy, I think
    ThePirateBay::SortBy::Name_asc    # Name ascending
    ThePirateBay::SortBy::Name_desc   # Name descending
    ThePirateBay::SortBy::Size        # Size, largest first
    ThePirateBay::SortBy::Seeders     # Most seeders first
    ThePirateBay::SortBy::Leechers    # Most leechers first
    ThePirateBay::SortBy::Type        # Type name descending
    ThePirateBay::SortBy::Uploaded    # Latest first

    # The following categories are available:
    ThePirateBay::Category::Audio
    ThePirateBay::Category::Video
    ThePirateBay::Category::Applications
    ThePirateBay::Category::Games
    ThePirateBay::Category::Others

ZOMG ZOMG WHERE ARE THE SPECS?!
-------------------------------
Yeah, no. I didn't write them.
The gem is fairly basic.
Still want them? Send me a pull-request.
