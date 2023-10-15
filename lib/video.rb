# frozen_string_literal: true

class Video
  # url, channel_url, publication_date, title, description, duration, view_count, like_count, comment_count
  attr_reader :url, :title, :description, :duration, :view_count, :like_count, :comment_count, :channel_url,
              :publication_date

  def initialize(attributes = {})
    @url = attributes[:url] || attributes['url']
    @channel_url = attributes[:channel_url] || attributes['channel_url']
    @publication_date = attributes[:publication_date] || attributes['publication_date']
    @title = attributes[:title] || attributes['title']
    @description = attributes[:description] || attributes['description']
    @duration = attributes[:duration] || attributes['duration']
    @view_count = attributes[:view_count] || attributes['view_count']
    @like_count = attributes[:like_count] || attributes['like_count']
    @comment_count = attributes[:comment_count] || attributes['comment_count']
  end
end
