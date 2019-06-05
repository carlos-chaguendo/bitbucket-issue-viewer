//
//  FiltrableArray.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/20/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit

/**
 * Array al cual se le puede aplicar un filtro, con la particularidad que conserva los valores originales
 * y los filtrados
 *
 *  ```
 *  var source: FiltrableArray<Int> = [2, 3, 4]
 *  source.forEach({print($0)})  // 2-3-4
 *
 *  source.filter({ $0 >= 4})
 *  source.forEach({print($0)})  // 4
 *
 *  source.removeFilter()
 *  source.forEach({print($0)})  // 2-3-4
 *  ```
 */
public struct FiltrableArray<Element> {

    fileprivate var original: [Element] = []
    fileprivate var filtered: [Element] = []
    public private(set) var filter: ((Element) -> Bool)?

    /// verifica si se esta filtrando o no
    fileprivate var source: [Element] {
        if filter == nil {
            return original
        }
        return filtered
    }

    public init() {

    }

    public init(from array: [Element]) {
        original = array
        filtered = []
    }

    public mutating func append(_ newElement: Element) {
        original.append(newElement)
    }

    public mutating func append(_ newElements: [Element]) {
        original.append(contentsOf: newElements)
    }

    /// Elimina  todos los elementos incluyendo el filtro
    public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        filter = nil
        original.removeAll(keepingCapacity: keepCapacity)
        filtered.removeAll(keepingCapacity: keepCapacity)
    }

    /// filtra los datos conservendo anteriores y filtrados
    public mutating func setFilter(_ isIncluded: @escaping (Element) -> Bool) {
        filter = isIncluded
        filtered = original.filter(isIncluded)
    }

    public mutating func removeFilter() {
        filter = nil
    }
}

extension FiltrableArray: Sequence {

    public typealias Iterator = IndexingIterator<[Element]>
    public func makeIterator() -> Iterator {
        return source.makeIterator()
    }
}

/// para que pueda crearse  [1,2,3,4]
extension FiltrableArray: ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: Element...) {
        self.init(from: elements)
    }
}

extension FiltrableArray: Collection {

    public subscript(index: Index) -> Element {
        return source[index]
    }

    public typealias Index = Int
    public var startIndex: Index { return source.startIndex }
    public var endIndex: Index { return source.endIndex }
    public var count: Int { return source.count }

    public func index(after index: Index) -> Index {
        return source.index(after: index)
    }
}

extension FiltrableArray where Element: Hashable {

    public mutating func remove(at index: Int) {
        if filter == nil {
            Logger.info("[FiltrableArray] Eliminando del original \(index)")
            original.remove(at: index)
        } else {
            // hay que eliminarlo del listado filtrado y del original
            Logger.info("[FiltrableArray]  Eliminando del filtrado \(index)")
            let filteredElement = filtered.remove(at: index)
            let originalELement = original.firstIndex(of: filteredElement)!
            Logger.info("[FiltrableArray]  Eliminando del original \(originalELement)")
            original.remove(at: originalELement)
        }
    }

    public subscript (safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }

    public subscript(index: Index) -> Element {
        get { return source[index] }
        set {
            if filter == nil {
                original[index] = newValue
            } else {
                // hay que actualizarlo del listado filtrado y del original
                let prev = filtered[index]
                let prevIndex = original.firstIndex(of: prev)!
                original[prevIndex] = newValue
                filtered[index] = newValue
            }
        }
    }
}

extension FiltrableArray {
    public mutating func sort(by sorter: (_ left: Element, _ right: Element) -> Bool) {
        original.sort(by: sorter)
        filtered.sort(by: sorter)
    }
}
