//
//  SequenceType+HashableEntity.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/20/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit

public class HashableObject<Object, Id: Hashable >: Hashable {
    public typealias Hash = (Object) -> Id
    public private(set) var entity: Object!
    private var hash: Hash!

    init(entity: Object, hash: @escaping Hash) {
        self.entity = entity
        self.hash = hash
    }

    init(entity: Object, id path: KeyPath<Object, Id>) {
        self.entity = entity
        self.hash = { (element: Object) -> Id in
            return element[keyPath: path]
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.hash(self.entity))
    }

    public static func == (lhs: HashableObject, rhs: HashableObject) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}

public extension Sequence {

    typealias ComparationResult = (commons: [Iterator.Element], added: [Iterator.Element], removed: [Iterator.Element])

    /// Crea una tupla (comunes,aggregados,eliminados) con las diferencias del array respecto a otro array dadas usando un comparador  de igualdad.
    /// El orden y las referencias de los valores de los resultados se determinan por la primera matriz.
    ///
    /// [Operaciones entre conjuntos ](https://www.portaleducativo.net/biblioteca/operaciones_de_conjuntos_15.jpg)
    /// - Parameters:
    ///   - with: el otro array con el que se realizara la comparacion
    ///   - using: El atributo que identifica a cada elemento del array como unico
    /// - Returns:
    ///   - commons: Elementos que estan presentes en ambos arrays
    ///   - added: Elementos que estan en el nuevo y no estan en el anterior array
    ///   - removed: Elementos que estaban en el anterio array y no estan presente en el nuevo
    ///
    public func differences<Id: Hashable>(with: [Iterator.Element], using path: KeyPath<Iterator.Element, Id>) -> ComparationResult {
        return differences(with: with, using: { $0[keyPath: path] })
    }

    /// Crea una tupla (comunes,aggregados,eliminados) con las diferencias del array respecto a otro array dadas usando un comparador  de igualdad.
    /// El orden y las referencias de los valores de los resultados se determinan por la primera matriz.
    ///
    /// [Operaciones entre conjuntos ](https://www.portaleducativo.net/biblioteca/operaciones_de_conjuntos_15.jpg)
    /// - Parameters:
    ///   - with: el otro array con el que se realizara la comparacion
    ///   - using: El atributo que identifica a cada elemento del array como unico
    /// - Returns:
    ///   - commons: Elementos que estan presentes en ambos arrays
    ///   - added: Elementos que estan en el nuevo y no estan en el anterior array
    ///   - removed: Elementos que estaban en el anterio array y no estan presente en el nuevo
    ///
    public func differences<Id: Hashable>(with: [Iterator.Element], using hash: @escaping HashableObject<Iterator.Element, Id>.Hash) -> ComparationResult {

        let previus = self.map { HashableObject(entity: $0, hash: hash) }
        let after = with.map { HashableObject(entity: $0, hash: hash) }

        var left = Set<HashableObject<Iterator.Element, Id>>(previus)
        var right = Set<HashableObject<Iterator.Element, Id>>(after)

        let commons = left.intersection(right)

        // Agregados
        right.subtract(commons)
        let add: [Iterator.Element] = right.map { $0.entity }

        // Eliminados
        left.subtract(commons)
        let removed: [Iterator.Element] = left.map { $0.entity }

        let com: [Iterator.Element] = commons.map { $0.entity }

        return (commons: com, added: add, removed: removed)
    }

}
