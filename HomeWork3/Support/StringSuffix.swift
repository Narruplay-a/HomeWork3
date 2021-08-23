//
//  StringSuffix.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 19.08.2021.
//

import Foundation

struct SuffixIterator: IteratorProtocol {
    let string: String
    var last: String.Index
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        self.last = string.endIndex
        self.offset = string.startIndex
    }
    
    mutating func next() -> Substring? {
        guard offset < last else { return nil }
        
        let sub: Substring = string[offset..<last]
        string.formIndex(after: &offset)
        return sub
    }
}

struct SuffixSequence: Sequence {
    let string: String
    
    func makeIterator() -> SuffixIterator {
        return SuffixIterator(string: string)
    }
}


struct SuffixArray {
    let dataSource: [String]
    var suffixes: [Substring: Int] = [:]
    
    init(dataSource: String) {
        let result = String(dataSource.unicodeScalars.filter(CharacterSet.whitespaces.union(CharacterSet.letters).union(CharacterSet(arrayLiteral: "-")).contains))
        self.dataSource = result.components(separatedBy: CharacterSet.whitespaces)
    }
    
    mutating func getSuffixes() {
        for string in dataSource {
            let sequence = SuffixSequence(string: string)
            for suffix in sequence {
                if let value = suffixes[suffix] {
                    suffixes.updateValue(value + 1, forKey: suffix)
                } else {
                    suffixes.updateValue(1, forKey: suffix)
                }
            }
        }
        
        print(suffixes)
    }
}

struct SuffixItem {
    let suffix: String
    let count: Int
}
