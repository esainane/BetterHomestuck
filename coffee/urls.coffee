
# this file contains logic to deal with url strings of he comic

baseURL = 'http://www.mspaintadventures.com/'

# a list of special connections in the comic
specialPageChains = [
    [4298, 4300]
    [4937, 4939]
    [4987, 4989]
    [9801, 9805]
    [6720, 6724] # jane flash game
    [6725, 6727] # jane flash game2
    # [6716]
]

# pages where both the forward/backward button should take you to the second page in the list
oneWayLinks = {
    6721: 6720
    6722: 6720
    6723: 6720

    6726: 6725
}

# these will get initialized at the bottom of this file
specialNextLinks = {}
specialPrevLinks = {}



# special pages that do not have "s=6&p=......" in them
specialPages = {
    1901: 'http://www.mspaintadventures.com/?s=6',
    7680: 'http://www.mspaintadventures.com/007680/007680.html'
    6715: 'http://www.mspaintadventures.com/DOTA/'
}
specialPages_reverse = {}
for pageNum, url of specialPages
    specialPages_reverse[url] = parseInt(pageNum)



# padds a integer with zeroes so it is of string length 6
# 1902 --> '001902'
pad6 = (pageNum) ->
  pad = '000000'
  str = '' + pageNum
  return pad.substring(0, pad.length - str.length) + str

# hussie <3<
isA6A5A1X2COMBO = (pageNum) -> return 7688 <= pageNum <= 7824

# returns the full url given the number of a page
makeUrl = (pageNum) ->
    console.assert typeof(pageNum) == 'number'

    if pageNum == 1900  # deal with the case of people trying to go backwards on the starting page
        pageNum = 1901

    php = ''
    if pageNum of specialPages       then return specialPages[pageNum]
    else if pageNum == 6009          then php = 'cascade.php'
    else if pageNum == 5982          then php = 'sbahj.php'
    else if 5664 <= pageNum <= 5981  then php = 'scratch.php'
    else if 8375 <= pageNum <= 8430  then php = 'ACT6ACT6.php'
    else if 7614 <= pageNum <= 7677  then php = 'trickster.php'
    else if isA6A5A1X2COMBO(pageNum) then php = 'ACT6ACT5ACT1x2COMBO.php'

    return baseURL + php + '?s=6&p=' + pad6(pageNum)

containsPageNumber = (url) ->
    if url of specialPages_reverse then return true
    return /p=(\d+)/.exec(url).length > 0


window.getPageNumber = (url) ->
    if url of specialPages_reverse
        return specialPages_reverse[url]
    return parseInt(/p=(\d+)/.exec(url)[1])

# gets the URL for the next page given the current one
window.nextUrl = (url) ->
    if url of specialNextLinks
        return specialNextLinks[url]
    pageNum = getPageNumber url
    if isA6A5A1X2COMBO pageNum
        pageNum += 2
    else
        pageNum += 1
    return makeUrl pageNum

# gets the URL for the next page given the current one
window.prevUrl = (url) ->
    if url of specialPrevLinks
        return specialPrevLinks[url]
    pageNum = getPageNumber url
    if isA6A5A1X2COMBO pageNum
        pageNum -= 2
    else
        pageNum -= 1
    return makeUrl pageNum

# returns true if the page should not be preloaded
window.isFlashPage = (url) ->
    if not containsPageNumber url
        return true
    return pad6(getPageNumber url) of window.flashPages

# validates whether a URL is part of the comic
window.isHomestuckUrl = (url) -> url.startsWith(baseURL) and containsPageNumber(url)





# # if the 1st argument is a pageNumber, it is converted into a url
# getUrl = (urlOrPageNum) ->
#     if typeof(urlOrPageNum) == 'string'
#         return urlOrPageNum
#     return makeUrl(urlOrPageNum)

for pageChain in specialPageChains
    for i in [0 .. pageChain.length - 2]
        prev = makeUrl(pageChain[i]  )
        next = makeUrl(pageChain[i+1])
        specialNextLinks[prev] = next
        specialPrevLinks[next] = prev

for from, to of oneWayLinks
    from = makeUrl(parseInt(from))
    to = makeUrl(to)
    specialNextLinks[from] = to
    specialPrevLinks[from] = to
