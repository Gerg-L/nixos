{ link, lavalinkPlugins }:
{

  server = {
    http2.enabled = false;
    port = link.portStr;
    address = link.ipv4;
  };
  lavalink = {
    pluginsDir = lavalinkPlugins;
    plugins = [
      {
        dependency = "dev.lavalink.youtube:youtube-plugin:1.13.0";
        enabled = true;
        snapshot = false;
      }
    ];
    server = {
      #password = "";

      bufferDurationMs = 400;
      filters = {
        channelMix = true;
        distortion = true;
        equalizer = true;
        karaoke = true;
        lowPass = true;
        rotation = true;
        timescale = true;
        tremolo = true;
        vibrato = true;
        volume = true;
      };
      frameBufferDurationMs = 5000;
      gc-warnings = true;
      nonAllocatingFrameBuffer = false;
      opusEncodingQuality = 10;
      playerUpdateInterval = 5;
      resamplingQuality = "LOW";
      soundcloudSearchEnabled = true;
      sources = {
        bandcamp = true;
        http = true;
        local = false;
        nico = true;
        soundcloud = true;
        twitch = true;
        vimeo = true;
        youtube = false;
      };
      trackStuckThresholdMs = 10000;
      useSeekGhosting = true;
      youtubePlaylistLoadLimit = 6;
      youtubeSearchEnabled = true;
    };
  };
  logging = {
    file.path = null;

    level = {
      "dev.lavalink.youtube.http.YoutubeOauth2Handler" = "INFO";
      lavalink = "INFO";
      root = "INFO";
    };
    request = {
      enabled = true;
      includeClientInfo = true;
      includeHeaders = false;
      includePayload = true;
      includeQueryString = true;
      maxPayloadLength = 10000;
    };
  };

  metrics.prometheus.enabled = false;

  plugins = {
    youtube = {
      allowDirectPlaylistIds = true;
      allowDirectVideoIds = true;
      allowSearch = true;
      clients = [ "TVHTML5EMBEDDED" ];
      enabled = true;
      oauth = {
        enabled = true;
        #refreshToken = "";
      };
    };
  };
  sentry = {
    dsn = "";
    environment = "";
  };
}
