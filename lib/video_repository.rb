# frozen_string_literal: true

require_relative 'video'
# require_relative 'parsing_service'
# require_relative 'crawling_service'
require 'csv'
require 'date'

class VideoRepository
  def initialize
    @videos = []
    # @parser = ParsingService.new
    # @crawler = CrawlingService.new
    @results = []
  end

  def all
    @videos
  end

  def add(url)
    @videos << Video.new(@parser.parse(url))
  end

  def crawl_list
    @crawler.crawl
  end

  # the following method should be called with the user inputted url from the interface
  def start; end
end
