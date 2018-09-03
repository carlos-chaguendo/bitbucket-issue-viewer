//
//  TableViewCellBackgroundView.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 31/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
/**
 * Vista para el estipo de seleccion  primario
 *  ```
 *  cell.selectedBackgroundView = TableViewCellPrimaryBackgroundView()
 *  ```
 * es preferible usar
 *  ```
 *  cell.selectionStyle = .none
 *  en el metodo
 *  setSelected(_:,animated:) {
 *   // fijar el color de fondo
 
 *  en el metodo
 *  func setHighlighted(_:,animated) {
 *   // fijar el color de fondo
 *  ```
 */
class TableViewCellBackgroundView: UIView {
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.backgroundColor = Colors.Cell.selected
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
