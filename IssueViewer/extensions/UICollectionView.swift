//
//  UICollectionView.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 2/20/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit


extension UICollectionView {
    
    func registerWithClass(_ cell: UICollectionViewCell.Type) {
        let className = String(describing: cell)
        register(cell, forCellWithReuseIdentifier: className)
    }
    
    func registerNibWithClass(_ cell: UICollectionViewCell.Type) {
        let className = String(describing: cell)
        register(UINib(nibName: className, bundle: nil), forCellWithReuseIdentifier: className)
    }
    
    func dequeueReusableCellWithClass<T>(_ className: String, forIndexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: className, for: forIndexPath) as? T
    }
    
    func dequeueReusableCellWithClass2<T: UICollectionViewCell>(_ cell: T.Type, forIndexPath: IndexPath) -> T? {
        let className = String(describing: cell)
        return dequeueReusableCell(withReuseIdentifier: className, for: forIndexPath) as? T
    }
    
}

extension UICollectionViewController {
    
    public func dequeue<T: UICollectionViewCell>( cell: T.Type, forIndexPath: IndexPath) -> T? {
        return collectionView?.dequeueReusableCellWithClass2(cell, forIndexPath: forIndexPath)
    }
    
}
