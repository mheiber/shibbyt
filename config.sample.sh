# helps to make pixlet binary be found: useful if running with cron
export PATH=$PATH:/Users/MY_NAME_HERE/homebrew/bin/
# from https://www.bingmapsportal.com/Application#, click "My keys"
# Note: The code doesn't actually using this anymore, can set to whatevs or update code
# to use it
export BING_KEY="Aodr0f-BuvJsak7RvBipTPSgIKYCNlB6dtpOcmq1Vy1aIigjBob3BBAwEg-x6-3z"

export SRC="Paddington Station London"
export DEST="Bank Station London"

# Last two segments part of the URI, find here:
# https://www.bbc.co.uk/weather/coast-and-sea/tide-tables
# Example is the station for London Bridge:
export TIDE_STATION="2/113"
export LAT="20.2000"
export LONG="10.0245"
