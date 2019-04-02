### Play twitch streams
twitch() {
 if [ ! -z "$1" ]
 then
  mpv https://www.twitch.tv/"$1" ytdl-format="bestvideo[height<=?720]+bestaudio/best" --autofit=50% --quiet 2>&1
 else
  echo "Usage: twitch [ kitboga riotgames loltyler1] "
 fi
}

### Listen to Di.FM with MPV
difm() {
 if [ ! -z "$1" ]
 then
  # get the key from lastpass
  DIKEY=`lpass show --notes "DIFM-listenKey"`
  # wrap around the mplayer output and just get the song title
  mpv --cache=no http://prem1.di.fm/$1?$DIKEY --quiet 2>&1 | while read -r line; do
  if grep "icy" <<< "$line" &>/dev/null; then
   song=$(grep -Po "icy-title: \K.*?(?=$)" <<< $line);
   echo "Playing: $song";
   notify-send mpvCLI "$song";
  fi;
  done
 else
  echo "Radio Station List: difm [chillstep, 00sclubhits, vocaltrance]"
  echo "For more: https://www.di.fm/settings"
 fi
}

## Chromecast with VLC ###
cast(){
 if [ ! -z "$1" ]
 then
  # fix this with DNS at some point
  vlc "$2" --sout "#chromecast" --sout-chromecast-ip="$1" --demux-filter=demux_chromecast
 else 
  echo "Chromecast Usage: $0 IP filename"
 fi
}

### Last pass function:
lpssh() {
 if [ ! -z "$1" ]
 then
  lpstatus=$(exec lpass status)
  if [[ ! $lpstatus =~ .*Not.* ]]
  then
   echo "Loading key: " "$1"
   lpass show --notes "$1" --field 'Private Key' | ssh-add -
  else
   echo "login to lastpass first..."
  fi
 else
  echo "I need a key to load!"
 fi
}

### TV Time!
watchtv() {
 TVHOST='http://192.168.1.39:5004'

 local OPTIND opt c r
 while getopts "rc:" opt; do
   case "${opt}" in
     c) # process channels
       CHANNEL="${OPTARG}"
       ;;
     r) # process remote
	   TVKEY=`lpass show --notes TVKEY`
       TVHOST="http://watchtv:"$TVKEY"@home.pinginfinity.com:9004"
       ;;
     \?) echo "Usage: "$0" [-c] ## [-r]"
       ;;
     :)
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
   esac
 done
 shift "$((OPTIND -1))"
 mpv "$TVHOST"/auto/v"$CHANNEL" --geometry=50%
}

### Generate a random string based on length
pwgen() {
 if [ ! -z "$1" ]
 then
  < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-$1};echo;
 else 
  echo 'Enter the length: pwgen $length'
 fi
}