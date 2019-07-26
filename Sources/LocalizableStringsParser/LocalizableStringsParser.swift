//
//  LocalizableStringsParser.swift
//  LocalizableStringsParser
//
//  Copyright (c) 2019 Nimble
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

open class LocalizableStringsParser {

    public static func parse(string: String, locale: String) -> LocalizableStringsFile {
        let string = string as NSString
        let regex = try! NSRegularExpression(pattern: #"(?:\/\*\ (.*)\ \*\/\n)?"(.*)"\ =\ "(.*)";"#)
        return .init(
            locale: locale,
            localizableStrings: regex.matches(in: string as String, range: string.range(of: string as String)).map { match in
                let descriptionRange = match.range(at: 1)
                let keyRange = match.range(at: 2)
                let valueRange = match.range(at: 3)
                return .init(
                    description: descriptionRange.length > 0 ? string.substring(with: descriptionRange) : nil,
                    key: string.substring(with: keyRange),
                    value: string.substring(with: valueRange)
                )
            }
        )
    }

    public static func merge(_ localizableStringsFiles: [LocalizableStringsFile],
                             to baseLocalizableStringsFile: LocalizableStringsFile) -> [CombinedLocalizableString] {
        var combinedLocalizableStrings: [CombinedLocalizableString] = []
        for baseLocalizableString in baseLocalizableStringsFile.localizableStrings {
            var values = [baseLocalizableStringsFile.locale: baseLocalizableString.value]
            for localizableStringsFile in localizableStringsFiles {
                if let localizableString = localizableStringsFile.localizableStrings.first(where: { $0.key == baseLocalizableString.key }) {
                    values[localizableStringsFile.locale] = localizableString.value
                }
            }
            combinedLocalizableStrings.append(.init(description: baseLocalizableString.description, key: baseLocalizableString.key, values: values))
        }
        return combinedLocalizableStrings
    }
}
