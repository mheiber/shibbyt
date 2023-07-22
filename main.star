load("html.star", "html")
load("http.star", "http")
load("render.star", "render")
load("time.star", "time")

# I set optmz=transfers. Alternative option is to optimize the route by time
BING_URL_TEMPLATE = "http://dev.virtualearth.net/REST/V1/Routes/Transit?wp.0=%s&wp.1=%s&timeType=Departure&dateTime=%s&output=json&optmz=transfers&key=%s"

TIDE_URL_TEMPLATE = "https://www.bbc.co.uk/weather/coast-and-sea/tide-tables/%s"

WEATHER_URL_TEMPLATE = r"https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&hourly=temperature_2m"

RED = "#a00"
LIGHT_BROWN = "#C4A484"
LIGHT_GRAY = "#d3d3d3"

def http_get(url):
    res = http.get(url, ttl_seconds = 60)
    if res.status_code != 200:
        fail("GET %s failed with status %d: %s", url, res.status_code, res.body())
    return res

def calc_weather_url(config):
    lat, long = config.get("LAT"), config.get("LONG")
    return WEATHER_URL_TEMPLATE % (lat, long)

def weather_dict_to_weather_str(weather_dict, hour):
    hourly = weather_dict["hourly"]["temperature_2m"]
    print(hour)
    sliced = hourly[hour:(hour + 18)]
    print(sliced[0:6])
    hourly_evens = [h for (i, h) in enumerate(sliced) if i % 2 == 0]
    print(hourly_evens[0:6])
    return " ".join([str(num) for num in hourly_evens])

def get_weather_str(config):
    weather_url = calc_weather_url(config)
    print(weather_url)
    weather_dict = http_get(weather_url).json()
    now = time.now()
    hour = now.hour if now.minute < 30 else now.hour + 1
    return weather_dict_to_weather_str(weather_dict, hour)

def render_weather_str(weather_str):
    return render.WrappedText(weather_str, color = LIGHT_GRAY)

def tide_html_to_tide_str(tide_html_str):
    def parse(selector, range_):
        results = []
        matches = html(tide_html_str).find(selector)
        for i in range_:
            match = matches.eq(i)
            results.append(match.text())
        return results

    times = parse(".wr-c-tide-time", range(0, 4))

    return times[1] + " " + times[3]

def get_tide_str(config):
    station = config.get("TIDE_STATION")
    tide_url = TIDE_URL_TEMPLATE % station
    print(tide_url)
    html = http_get(tide_url).body()
    return tide_html_to_tide_str(html) + " " + str(time.now().minute)

def render_tide_str(tide_str):
    return render.Text(tide_str, color = LIGHT_BROWN)

def do_render(rows):
    return render.Root(render.Column(children = rows))

def main(config):
    tide_str = get_tide_str(config)
    tide_row = render_tide_str(tide_str)

    weather_str = get_weather_str(config)
    weather_row = render_weather_str(weather_str)

    return do_render([tide_row, weather_row])
