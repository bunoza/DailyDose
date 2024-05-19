/*
 Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

 */

import Foundation

struct Pages: Codable {
    let type: String?
    let title: String?
    let displaytitle: String?
    let namespace: Namespace?
    let wikibase_item: String?
    let titles: Titles?
    let pageid: Int?
    let lang: String?
    let dir: String?
    let revision: String?
    let tid: String?
    let timestamp: String?
    let content_urls: ContentURLs?
    let extract: String?
    let extract_html: String?
    let normalizedtitle: String?
    let thumbnail: Thumbnail?
    let originalimage: OriginalImage?

    enum CodingKeys: String, CodingKey {
        case type
        case title
        case displaytitle
        case namespace
        case wikibase_item
        case titles
        case pageid
        case lang
        case dir
        case revision
        case tid
        case timestamp
        case content_urls
        case extract
        case extract_html
        case normalizedtitle
        case thumbnail
        case originalimage
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        displaytitle = try values.decodeIfPresent(String.self, forKey: .displaytitle)
        namespace = try values.decodeIfPresent(Namespace.self, forKey: .namespace)
        wikibase_item = try values.decodeIfPresent(String.self, forKey: .wikibase_item)
        titles = try values.decodeIfPresent(Titles.self, forKey: .titles)
        pageid = try values.decodeIfPresent(Int.self, forKey: .pageid)
        lang = try values.decodeIfPresent(String.self, forKey: .lang)
        dir = try values.decodeIfPresent(String.self, forKey: .dir)
        revision = try values.decodeIfPresent(String.self, forKey: .revision)
        tid = try values.decodeIfPresent(String.self, forKey: .tid)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        content_urls = try values.decodeIfPresent(ContentURLs.self, forKey: .content_urls)
        extract = try values.decodeIfPresent(String.self, forKey: .extract)
        extract_html = try values.decodeIfPresent(String.self, forKey: .extract_html)
        normalizedtitle = try values.decodeIfPresent(String.self, forKey: .normalizedtitle)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        originalimage = try values.decodeIfPresent(OriginalImage.self, forKey: .originalimage)
    }
}
