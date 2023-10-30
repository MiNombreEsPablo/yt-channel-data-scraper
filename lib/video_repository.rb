# frozen_string_literal: true

require_relative 'video'
require_relative 'parsing_service'
require_relative 'crawling_service'
require 'csv'
require 'date'

class VideoRepository
  attr_reader :channel_url

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
    @results.each_with_index do |url, index|
      puts "Progress: #{index + 1} out of #{@results.size} (#{100 * (index + 1) / @results.size}%)"
      add(url)
    end
    dump_to_csv
    puts "#{all.size} videos from #{@channel_url} have been added to the file.}"
  end

  private

  def dump_to_csv
    CSV.open('videos.csv', 'w') do |csv|
      csv << %w[title url channel_url publication_date description duration view_count like_count sample_date]
      @videos.each do |video|
        csv << [video.title, video.url, @channel_url, video.publication_date, video.description, video.duration,
                video.view_count, video.like_count, Date.today]
      end
    end
  end
end
