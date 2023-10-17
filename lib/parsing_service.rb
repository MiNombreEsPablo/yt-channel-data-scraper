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

      subtitles = fetch_subtitles(youtube, video_id)

      result = {
        title: video.snippet.title,
        description: video.snippet.description,
        publication_date: video.snippet.published_at,
        duration: video.content_details.duration,
        view_count: video.statistics.view_count.to_i,
        like_count: video.statistics.like_count.to_i,
        subtitles: subtitles,
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

  def fetch_subtitles(youtube, video_id)
    captions_response = youtube.list_captions('snippet', video_id: video_id)
    captions = captions_response.items.map { |caption| caption.snippet.title }

    captions.empty? ? 'No subtitles available' : captions.join(', ')
  end
end
