# frozen_string_literal: true

require 'google/apis/youtube_v3'
require 'dotenv'
Dotenv.load

class ParsingService
  def parse(url)
    video_id = extract_video_id(url)
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = ENV['YOUTUBE_API_KEY']

    begin
      video_response = youtube.list_videos('snippet,statistics,contentDetails', id: video_id)
      video = video_response.items.first

      result = {
        title: video.snippet.title,
        description: video.snippet.description,
        publication_date: video.snippet.published_at,
        duration: video.content_details.duration,
        view_count: video.statistics.view_count.to_i,
        like_count: video.statistics.like_count.to_i
      }

      result.merge(url: url)
    rescue StandardError => e
      puts "Error fetching video information: #{e.message}"
    end
  end

  private

  def extract_video_id(url)
    url.match(%r{(?:youtu\.be/|youtube\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^"&?/\s]{11})})[1]
  end
end
