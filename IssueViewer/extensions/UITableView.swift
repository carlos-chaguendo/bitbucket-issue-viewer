//
//  UITableView.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import struct Core.Logger

extension UITableView {

	func registerWithClass(_ cell: UITableViewCell.Type) {
		let className = String(describing: cell)
		register(cell, forCellReuseIdentifier: className)
	}

	func registerNibWithClass(_ cell: UITableViewCell.Type) {
		let className = String(describing: cell)
		register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
	}

	func dequeueReusableCellWithClass<T>(_ cell: T.Type) -> T? {
		let className = String(describing: cell)
		return dequeueReusableCell(withIdentifier: className) as? T
	}

	/// Los headers de las tablas no son dinamicos
	/// se necesita llamar a este metodo en `override func viewDidLayoutSubviews() {` o cuando se necesite
	func sizeHeaderToFit() {
		if let headerView = self.tableHeaderView {

			let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
			var headerFrame = headerView.frame

			//Comparison necessary to avoid infinite loop
			if height != headerFrame.size.height {
				headerFrame.size.height = height
				headerView.frame = headerFrame
				self.tableHeaderView = headerView
			}
		}
	}
    
    
    
    /**
     * Metodo de utilidad para mostrar el registro de indices a actualizar, con el fin de evaluar cuandor se precenta
     * la excepcion `NSInternalInconsistency...`
     *
     * __No usar en produccion__
     */
    func _DEBUG_BatchUpdate() {
        
        let printMutable: (NSMutableArray) -> Void = {
            $0.forEach { (e) in
                if let index = (e as! NSObject).value(forKey: "indexPath") as? IndexPath {
                    Logger.info("  Section \(index.section) - \(index.row)")
                }
            }
        }
        
        if let reloadItems = value(forKey: "_insertItems") as? NSMutableArray {
            Logger.info("_insertItems")
            printMutable(reloadItems)
        }
        
        if let reloadItems = value(forKey: "_deleteItems") as? NSMutableArray {
            Logger.info("_deleteItems")
            printMutable(reloadItems)
        }
        
        if let reloadItems = value(forKey: "_reloadItems") as? NSMutableArray {
            Logger.info("_reloadItems")
            printMutable(reloadItems)
        }
        
    }

}
