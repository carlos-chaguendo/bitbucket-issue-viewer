//
//  SequenceType.swift
//  AdivantusCore
//
//  Created by carlos chaguendo on 1/06/16.
//  Copyright © 2016 Mayorgafirm. All rights reserved.
//

public extension Sequence {


	public func groupBy<U : Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
		var dict: [U: [Iterator.Element]] = [:]
		for el in self {
			let key = keyFunc(el)
			if case nil = dict[key]?.append(el) { dict[key] = [el] }
		}
		return dict
	}


	public func countBy<U : Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U: Int] {
		var dict: [U: Int] = [:]
		for el in self {
			let key = keyFunc(el)
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

public extension Collection where Index == Int {
    
    public subscript (safe index: Index) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
    
}



public extension Array {

	/// Removes all elements from an array that the callback returns true.
	///
	/// :return Array with removed elements.
	public mutating func remove( callback: (Iterator.Element) -> Bool) -> [Iterator.Element] {

		var index = 0
		var removed: [Iterator.Element] = []

		for el in self {
			if callback(el) == true {
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

		for el in self {
			if when(el) == true {
				removed.append(self[index])
				self.remove(at: index)
				self.insert(newElement, at: index)
			}
			index += 1
		}

		return removed.count == 0 ? nil : removed
	}




}
