import re
import urllib3

URL = 'https://propakistani.pk/2021/05/03/fbr-raises-customs-of-mg-vehicles-by-14-5-percent/'
REQUEST_TYPE = 'GET'

html = urllib3.PoolManager().request(REQUEST_TYPE, URL).data.decode('utf-8')
mainContent = re.compile('<div id="page">(.*?)<div class="menu-overlay">', re.DOTALL).search(html)
mainContent = mainContent.group(1)

filter = re.compile('<.*?>')
cleanText = re.sub(filter, '', mainContent)

f = open('demofile.txt', 'w')
f.write(cleanText)
f.close()