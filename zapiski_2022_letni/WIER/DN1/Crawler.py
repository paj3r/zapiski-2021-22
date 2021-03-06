import urllib

WEB_PAGE_ADDRESS = "http://evem.gov.si"

print(f"Retrieving web page URL '{WEB_PAGE_ADDRESS}'")

request = urllib.request.Request(
    WEB_PAGE_ADDRESS,
    headers={'User-Agent': 'fri-ieps-TEST'}
)

with urllib.request.urlopen(request) as response:
    html = response.read().decode("utf-8")
    print(f"Retrieved Web content: \n\n'\n{html}\n'")