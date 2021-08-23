//
//  SuffixScreenModel.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 20.08.2021.
//


import SwiftUI
import Combine

final class SuffixScreenModel: ObservableObject {
    private var inputString: String = ""
    private var suffixArray: SuffixArray = .init(dataSource: "")
    private var suffixItems: [SuffixItem] = []
    private var cancellables: Set<AnyCancellable> = Set()
    
    @Published
    var pickerSelection: Int = 0
    @Published
    var isAscending: Bool = true
    @Published
    var searchString: String = ""
    @Published
    var threeLetterSuffixItems: [SuffixItem] = []
    @Published
    var sortedSuffixItems: [SuffixItem] = []
    
    var popularRange: Range<Int> {
        return 0..<(threeLetterSuffixItems.count > 10 ? 10 : threeLetterSuffixItems.count)
    }
    
    func updateModel() {
        inputString = UserDefaults.standard.string(forKey: "shared_text") ?? ""
        suffixArray = SuffixArray(dataSource: inputString)
        suffixArray.getSuffixes()
        suffixItems = []

        for item in suffixArray.suffixes {
            suffixItems.append(SuffixItem(suffix: String(item.key), count: item.value))
        }
        
        sortedSuffixItems = suffixItems
        threeLetterSuffixItems = suffixItems
            .filter{ item in
                item.suffix.count == 3
            }.sorted { one, two in
                return one.count > two.count
            }
        
        $isAscending.map { [weak self] value in
            guard let self = self else { return [] }
            
            if value {
                return self.sortedSuffixItems.sorted { $0.suffix.lowercased() < $1.suffix.lowercased() }
            } else {
                return self.sortedSuffixItems.sorted { $0.suffix.lowercased() > $1.suffix.lowercased() }
            }
        }
        .assign(to: \.sortedSuffixItems, on: self)
        .store(in: &cancellables)
        
        $searchString
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { [weak self] value in
            guard let self = self else { return [] }
            
            guard value.count > 0 else {
                self.sortedSuffixItems = self.suffixItems
                
                return self.sortedArray(self.sortedSuffixItems)
            }
            
            let tempData = self.sortedSuffixItems.filter { item in
                return item.suffix.lowercased().hasPrefix(value.lowercased())
            }
            
            return self.sortedArray(tempData)
        }
        .assign(to: \.sortedSuffixItems, on: self)
        .store(in: &cancellables)
        
        WidgetService.updateWidgetData(with: threeLetterSuffixItems)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}

private extension SuffixScreenModel {
    func sortedArray(_ array: [SuffixItem]) -> [SuffixItem] {
        if isAscending {
            return array.sorted { $0.suffix.lowercased() < $1.suffix.lowercased() }
        } else {
            return array.sorted { $0.suffix.lowercased() > $1.suffix.lowercased() }
        }
    }
}

