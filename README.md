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

    # Page, sort and category is optional - (query, page, sort, category)
    # Page 2 is actually page 3, you know the drill
    ThePirateBay::Search.new('query', 2, ThePirateBay::SortBy::Seeders, ThePirateBay::Category::Video).results

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