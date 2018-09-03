//
//  Colors.swift
//  test-ios
//
//  Created by carlos chaguendo on 28/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

public struct Colors {

    public static let primary: UIColor = #colorLiteral(red: 0.1254901961, green: 0.3137254902, blue: 0.5058823529, alpha: 1)
    //public static let primary: UIColor = #colorLiteral(red: 0.02745098039, green: 0.2784313725, blue: 0.6509803922, alpha: 1)

    public static let navbar_back: UIColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.968627451, alpha: 1)
    public static let navbar_button: UIColor = primary
    public static let navbar_title: UIColor = #colorLiteral(red: 0.2588235294, green: 0.3215686275, blue: 0.431372549, alpha: 1)
    public static let separator_color = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)

    public static let status_bar: UIColor = navbar_back
    public static let controller_background: UIColor = #colorLiteral(red: 0.9176470588, green: 0.9254901961, blue: 0.9411764706, alpha: 1)

    public static let activity_indicator: UIColor = primary



    public struct TapBar {
        public static let background: UIColor = status_bar
        public static let tint: UIColor = primary
        public static let topBorder:UIColor = UIColor.Hex(0xe9eaec)
    }
    
    public struct Cell {
        
        /// primario al 10%
        public static let selected: UIColor = #colorLiteral(red: 0.1254901961, green: 0.3137254902, blue: 0.5058823529, alpha: 0.09871069785)
    }

}

extension UIView {
    
    /// Vista para las tablas selecionadas
    public static let tableViewCellSelected: UIView = TableViewCellBackgroundView()
}
