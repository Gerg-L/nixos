{
  link,
  ferretLink,
  p,
}:
{
  activity = [
    {
      name = "/help";
      status = "online";
      type = "listening";
    }
  ];
  aliases = {
    connect = [ "join" ];
    leave = [
      "stop"
      "bye"
    ];
    play = [ "p" ];
    view = [ "v" ];
  };
  bot_access_user = [ ];
  client_id = p."vocard/client_id";
  cooldowns = {
    connect = [
      2
      30
    ];
    "playlist view" = [
      1
      30
    ];
  };
  default_controller = {
    default_buttons = [
      [
        "back"
        "resume"
        "skip"
        { stop = "red"; }
        "add"
      ]
      [ "tracks" ]
    ];
    disableButtonText = false;
    embeds = {
      active = {
        author = {
          icon_url = "@@bot_icon@@";
          name = "Music Controller | @@channel_name@@";
        };
        color = "@@track_color@@";
        description = "**Now Playing: ```[@@track_name@@]```\nLink: [Click Me](@@track_url@@) | Requester: @@requester@@ | DJ: @@dj@@**";
        footer.text = "Queue Length: @@queue_length@@ | Duration: @@track_duration@@ | Volume: @@volume@@% {{loop_mode != 'Off' ?? | Repeat: @@loop_mode@@}}";
        image = "@@track_thumbnail@@";
      };
      inactive = {
        color = "@@default_embed_color@@";
        description = "[Support](@@server_invite_link@@) | [Invite](@@invite_link@@) | [Questionnaire](https://forms.gle/Qm8vjBfg2kp13YGD7)";
        image = "https://i.imgur.com/dIFBwU7.png";
        title.name = "There are no songs playing right now";
      };
    };
  };
  default_max_queue = 1000;
  default_voice_status_template = "{{@@track_name@@ != 'None' ?? @@track_source_emoji@@ Now Playing: @@track_name@@ // Waiting for song requests}}";
  embed_color = "0xb3b3b3";
  genius_token = "YOUR_GENIUS_TOKEN";
  ipc_client = {
    enable = false;
    host = "127.0.0.1";
    password = "YOUR_PASSWORD";
    port = 8000;
    secure = false;
  };
  logging = {
    file = {
      enable = false;
      path = "./logs";
    };
    level = {
      discord = "INFO";
      ipc_client = "INFO";
      vocard = "INFO";
    };
    max-history = 30;
  };
  lyrics_platform = "lyrist";
  mongodb_name = "vocard";
  mongodb_url = ferretLink.url;
  nodes.DEFAULT = {
    host = link.hostname;
    identifier = "DEFAULT";
    password = p."vocard/password";
    inherit (link) port;
    secure = false;
  };
  prefix = "?";
  sources_settings = {
    apple = {
      color = "0xE298C4";
      emoji = "<:applemusic:994844332374884413>";
    };
    bandcamp = {
      color = "0x6F98A7";
      emoji = "<:bandcamp:864694003811221526>";
    };
    reddit = {
      color = "0xFF5700";
      emoji = "<:reddit:996007566863773717>";
    };
    soundcloud = {
      color = "0xFF7700";
      emoji = "<:soundcloud:852729280027033632>";
    };
    spotify = {
      color = "0x1DB954";
      emoji = "<:spotify:826661996615172146>";
    };
    tiktok = {
      color = "0x74ECE9";
      emoji = "<:tiktok:996007689798811698>";
    };
    twitch = {
      color = "0x9B4AFF";
      emoji = "<:twitch:852729278285086741>";
    };
    vimeo = {
      color = "0x1ABCEA";
      emoji = "<:vimeo:864694001919721473>";
    };
    youtube = {
      color = "0xFF0000";
      emoji = "<:youtube:826661982760992778>";
    };
    "youtube music" = {
      color = "0xFF0000";
      emoji = "<:youtube:826661982760992778>";
    };
  };
  spotify_client_id = p."vocard/spotify_client_id";
  spotify_client_secret = p."vocard/spotify_client_secret";
  token = p."vocard/token";
  version = "v2.7.1";
}
