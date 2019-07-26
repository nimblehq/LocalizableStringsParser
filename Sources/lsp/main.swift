//
//  main.swift
//  lsp
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
import Bouncer
import LocalizableStringsParser

let parseCommand = Command(name: ["parse"], operandType: .range(1...Int.max)) { _, _, operands, _ in
    let localizableStringsFiles = operands
        .map { URL(fileURLWithPath: $0) }
        .map { fileURL -> LocalizableStringsFile in
            let string = try! String(contentsOf: fileURL.appendingPathComponent("Localizable.strings"), encoding: .utf8)
            let locale = fileURL.deletingPathExtension().lastPathComponent
            return LocalizableStringsParser.parse(string: string, locale: locale)
        }
    let base = localizableStringsFiles[0]
    let combinedLocalizableString = LocalizableStringsParser.merge(Array(localizableStringsFiles.dropFirst()), to: base)
    let encodedData = try! JSONEncoder().encode(combinedLocalizableString)
    let destinationPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("localizable.json")
    try! encodedData.write(to: destinationPath)
}

let program = Program(commands: [parseCommand])
let arguments = Array(CommandLine.arguments.dropFirst())
do {
    try program.run(withArguments: arguments)
} catch {
    print(error.localizedDescription)
}
