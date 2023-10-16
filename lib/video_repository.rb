# frozen_string_literal: true

require_relative 'video'
require_relative 'parsing_service'
require_relative 'crawling_service'
require 'csv'
require 'date'

class VideoRepository
  def initialize
    @videos = []
    @parser = ParsingService.new
    @crawler = CrawlingService.new
    @results = []
    @channel_url = ''
  end

  def all
    @videos
  end

  def add(url)
    video = @parser.parse(url)
    video.merge!(channel_url: @channel_url)
    @videos << Video.new(@parser.parse(url))
  end

  def crawl_list
    @crawler.crawl(@channel_url)
  end

  # the following method should be called with the user inputted url from the interface
  def start
    puts 'Enter a channel url'
    @channel_url = gets.chomp
    @results = crawl_list
    @results.each do |url|
      add(url)
    end
    dump_to_csv
  end

  private

  def dump_to_csv
    CSV.open('videos.csv', 'w') do |csv|
      csv << %w[title url channel_url publication_date description duration view_count like_count sample_date]
      @videos.each do |video|
        csv << [video.title, video.url, video.channel_url, video.publication_date, video.description, video.duration,
                video.view_count, video.like_count, Date.today]
      end
    end
  end
end
