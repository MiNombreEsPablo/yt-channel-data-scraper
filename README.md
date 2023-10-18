# yt-channel-data-scraper

This Ruby program is designed to scrape information about videos from a YouTube channel, utilizing web scraping techniques and the YouTube API. The program consists of three main components: a `Video` class for representing video objects, a `ParsingService` class for extracting video information using the YouTube API, and a `CrawlingService` class for crawling a YouTube channel to collect video URLs.

Runing the program creates a `videos.csv` file that contains the following contents for the last 1,020 videos uploaded to the propmted channel:

- Title of the video
- Url of the video
- Url of the channel
- Publication date
- Video description
- View count at the moment of sampling
- Like count at the moment of sampling
- Sample date

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Classes](#classes)
- [Contributing](#contributing)

## Installation

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/MiNombreEsPablo/yt-channel-data-scraper
   ```

2. Install the required gems:

   ```bash
   bundle install
   ```

3. Create a `.env` file in the root directory and add your YouTube API key:

   ```env
   YOUTUBE_API_KEY=your-api-key
   ```

## Usage

To use the YouTube video scraper, follow these steps:

1. Run the script:

   ```bash
   ruby lib/interface.rb
   ```

2. Enter the URL of the YouTube channel when prompted.

3. The program will crawl the channel, extract video URLs, fetch information using the YouTube API, and store the information in a CSV file (`videos.csv`).

## Dependencies

The program relies on the following Ruby gems:

- `google/apis/youtube_v3`: For interacting with the YouTube API.
- `dotenv`: For handling environment variables.
- `nokogiri`: For HTML parsing.
- `watir`: For browser automation.
- `webdrivers`: For managing browser drivers.

Make sure to install these gems using `bundle install` before running the program.

## Classes

### Video Class

Represents a YouTube video with attributes such as URL, channel URL, publication date, title, description, duration, view count, and like count.

### ParsingService Class

Uses the YouTube API to fetch detailed information about a video. It extracts the video ID from the URL and queries the API for video details.

### CrawlingService Class

Utilizes Watir, Nokogiri, and Selenium to crawl a YouTube channel and extract video URLs. It simulates user interaction to navigate to the videos tab, expands the page to load all videos, and parses the HTML to obtain video URLs.

### VideoRepository Class

Manages a collection of videos, handles interaction with parsing and crawling services, and provides methods for adding videos, retrieving all videos, crawling a list of videos from a channel, and starting the process by taking user input for the channel URL. The collected video information is dumped into a CSV file.

## Contributing

Feel free to contribute to the project by opening issues or pull requests.
