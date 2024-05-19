/*
 Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

 */

import Foundation

struct Selected: Codable {
    let text: String?
    let pages: [Pages]?
    let year: Int?

    enum CodingKeys: String, CodingKey {
        case text
        case pages
        case year
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        pages = try values.decodeIfPresent([Pages].self, forKey: .pages)
        year = try values.decodeIfPresent(Int.self, forKey: .year)
    }
}

extension Selected: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    static func == (lhs: Selected, rhs: Selected) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension [Selected] {
    func removeDuplicates() -> [Selected] {
        return Array(Set(self)).sorted(by: { $0.year ?? -1 > $1.year ?? -1 })
    }
}
