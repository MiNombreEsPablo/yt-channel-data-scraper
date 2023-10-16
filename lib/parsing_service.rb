# frozen_string_literal: true

# Path: lib/parsing_service.rb
# The parsing service is responsible for getting the deisred attributes from a video
# url, channel_url, publication_date, title, description, duration, view_count, like_count

gem 'selenium-webdriver', '4.10.0'
gem 'webdrivers', '5.3.1'

# require 'open-uri'
require 'nokogiri'
require 'watir'
require 'webdrivers'

# USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'

class ParsingService
  def parse(url)
    browser = Watir::Browser.new :chrome, options: { args: %w[--remote-debugging-port=9222] }
    browser.goto(url)
    description_expander(browser)
    html = browser.html
    doc = Nokogiri::HTML.parse(html, nil, 'utf-8')
    result = scrape(doc)
    result = result.merge(url: url)
    browser.close
    result
  end

  private

  def description_expander(browser)
    expand_description = browser.element(css: '#expand')
    expand_description.click
  end

  def scrape(doc)
    description = doc.css('#description-inline-expander yt-attributed-string').first.text
    title = doc.css('#container > h1 > yt-formatted-string').text
    vidinfo = doc.css('#info span')
    publication_date = vidinfo[2].text
    view_count = vidinfo[0].text.gsub(/[^0-9]/, '').to_i
    duration = doc.css('.ytp-time-duration').text
    like_count = doc.css('.yt-core-attributed-string.yt-core-attributed-string--white-space-no-wrap')[8].text
    { description: description, title: title, publication_date: publication_date, duration: duration,
      view_count: view_count, like_count: like_count }
  end
end
