# frozen_string_literal: true

# Path: lib/parsing_service.rb
# The parsing service is responsible for getting the deisred attributes from a video
# url, channel_url, publication_date, title, description, duration, view_count, like_count, comment_count

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
    scrape(doc)
  end

  private

  def description_expander(browser)
    expand_description = browser.element(css: '#expand')
    expand_description.click
  end

  def scrape(doc)
    description = doc.css('#description-inline-expander').text
    title = doc.css('#container > h1 > yt-formatted-string').text
    publication_date = 'pending'
    duration = 'pending'
    view_count = 'pending'
    like_count = 'pending'
    comment_count = 'pending'
    { description: description, title: title, publication_date: publication_date, duration: duration,
      view_count: view_count, like_count: like_count, comment_count: comment_count }
  end
end
