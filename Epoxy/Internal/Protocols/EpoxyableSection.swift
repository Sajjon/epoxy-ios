//  Created by Laura Skelton on 9/6/17.
//  Copyright © 2017 Airbnb. All rights reserved.

import Foundation

public protocol EpoxyableSection {

  /// The dataID of this section
  var dataID: String { get }

  /// The array of items to display in this section
  var itemModels: [EpoxyableModel] { get }

  /// Gets the cell reuse IDs from the given external sections
  func getCellReuseIDs() -> Set<String>

  /// Gets the supplementary view reuse IDs by kind from the given external sections
  func getSupplementaryViewReuseIDs() -> [String: Set<String>]

}

extension Array where Element: EpoxyableSection {

  public func getCellReuseIDs() -> Set<String> {
    var newReuseIDs = Set<String>()
    forEach { section in
      newReuseIDs = newReuseIDs.union(section.getCellReuseIDs())
    }
    return newReuseIDs
  }

  public func getSupplementaryViewReuseIDs() -> [String: Set<String>] {
    var newReuseIDs = [String: Set<String>]()
    forEach { section in
      let sectionReuseIDs = section.getSupplementaryViewReuseIDs()
      sectionReuseIDs.forEach { elementKind, reuseIDs in
        let existingSet = newReuseIDs[elementKind] ?? Set<String>()
        newReuseIDs[elementKind] = existingSet.union(reuseIDs)
      }
    }
    return newReuseIDs
  }
}

extension EpoxySection: EpoxyableSection {

  public enum ElementKind: String {
    case sectionHeader
  }

  public var itemModels: [EpoxyableModel] {
    return items
  }

  public func getCellReuseIDs() -> Set<String> {
    var newCellReuseIDs = Set<String>()
    items.forEach { item in
      newCellReuseIDs.insert(item.reuseID)
    }
    return newCellReuseIDs
  }

  public func getSupplementaryViewReuseIDs() -> [String: Set<String>] {
    var reuseIDs = Set<String>()
    if let sectionHeader = sectionHeader {
      reuseIDs.insert(sectionHeader.reuseID)
    }
    return [ElementKind.sectionHeader.rawValue: reuseIDs]
  }
}