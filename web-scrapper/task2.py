# filter main heading and its content only

import re
import urllib3

URL = 'https://propakistani.pk/2021/05/03/60-year-old-mr-pakistan-sets-his-eyes-on-mr-asia-title-in-india-next-year/'
REQUEST_TYPE = 'GET'

html = urllib3.PoolManager().request(REQUEST_TYPE, URL).data.decode('utf-8')

# heading text
headingTxt = re.compile('<h1 class="entry-title">(.*?)</h1>', re.DOTALL).search(html)
headingTxt = headingTxt.group(1)

# content text
content = re.compile('<div class="the-post-content">(.*?)<div id="post-author">', re.DOTALL).search(html)
content = content.group(1)
content = re.compile('<p.*?>(.*?)</p.*?>', re.DOTALL).findall(content)

cleanTxt = ''
for i in content:
  cleanTxt += '\n'+i

f = open('demofile.txt', 'w')
f.write(headingTxt + '\n\n' + cleanTxt)
f.close()