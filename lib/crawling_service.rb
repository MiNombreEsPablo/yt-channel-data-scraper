# frozen_string_literal: true

gem 'selenium-webdriver', '4.10.0'
gem 'webdrivers', '5.3.1'

require 'nokogiri'
require 'watir'
require 'webdrivers'

class CrawlingService
  attr_reader :list

  def initialize
    @previous_videos = 0
    @list = []
  end

  def crawl(url)
    browser = Watir::Browser.new :chrome, options: { args: %w[--remote-debugging-port=9222] }
    browser.goto(url)

    begin
      goto_videos(browser)
      sleep(1)
      expand_loop(browser)
      puts 'All videos loaded'
      sleep(1)
      html = browser.html
      parse(html)
      @list
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    ensure
      browser.close
    end
  end

  private

  def goto_videos(browser)
    puts 'Going to videos tab'
    videos_tab = browser.element(text: 'Videos')
    videos_tab.click
  end

  def expand_loop(browser)
    loop do
      current_videos = browser.elements(css: 'a#video-title-link').count

      break if current_videos == @previous_videos || current_videos > 5000

      browser.scroll.by(0, 9_999_999_999)
      sleep(1)
      puts "Number of videos: #{current_videos}"
      @previous_videos = current_videos
    end
  end

  def parse(html)
    doc = Nokogiri::HTML.parse(html, nil, 'utf-8')
    links = doc.css('a#video-title-link')
    links.each do |link|
      @list << "https://www.youtube.com/#{link['href'].split('&')[0]}"
    end
  end
end
