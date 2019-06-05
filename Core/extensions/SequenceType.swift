//
//  SequenceType.swift
//  AdivantusCore
//
//  Created by carlos chaguendo on 1/06/16.
//  Copyright © 2016 Mayorgafirm. All rights reserved.
//

extension Sequence {

    public func groupBy<U: Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var dict: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = keyFunc(element)
            if case nil = dict[key]?.append(element) { dict[key] = [element] }
        }
        return dict
    }

    public func countBy<U: Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U: Int] {
        var dict: [U: Int] = [:]
        for element in self {
            let key = keyFunc(element)
            if dict[key] == nil {
                dict[key] = 1
            } else {
                dict[key] = dict[key]! + 1
            }

            //if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }

}

extension Collection where Index == Int {

    public subscript (safe index: Index) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }

    /// Si el array no esta vacio se asegura de obtener un elemento del array
    /// si el indice esta por encima del tamanio del array obtiene el ultimo elemento
    /// si el indice esta por debajo 0 obtiene el primer elemento
    ///
    ///     let nums = [0,1,2,3,4,5]
    ///     nums[clamp: 6] ///  return 5
    ///     nums[clamp: 3] ///  return 3
    ///     nums[clamp: -5] ///  return 0
    ///
    /// - Returns: Nil si el araray esta vacio
    public subscript(clamp index: Index) -> Element? {
        if self.isEmpty {
            return nil
        }
        let index = clamp(index, between: 0, and: self.count - 1)
        return self[index]
    }
}

extension Array {

    /// Removes all elements from an array that the callback returns true.
    ///
    /// :return Array with removed elements.
    public mutating func remove( callback: (Iterator.Element) -> Bool) -> [Iterator.Element] {

        var index = 0
        var removed: [Iterator.Element] = []

        for element in self {
            if callback(element) == true {
                removed.append(self[index])
                self.remove(at: index)
            }
            index += 1
        }

        return removed
    }

    /// Replace all elements from an array that the callback returns true.
    ///
    /// :return Array with replaced elements.
    public mutating func replace(by newElement: Iterator.Element, when: (Iterator.Element) -> Bool) -> [Iterator.Element]? {

        var index = 0
        var removed: [Iterator.Element] = []

        for element in self {
            if when(element) == true {
                removed.append(self[index])
                self.remove(at: index)
                self.insert(newElement, at: index)
            }
            index += 1
        }

        return removed.count == 0 ? nil : removed
    }

}
