//
//  HtmlParser.swift
//  Core
//
//  Created by Carlos Chaguendo on 30/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import Atributika
import Core

class HtmlParser {

    public static let h3 = Style("h3")
        .font(.boldSystemFont(ofSize: 15))
        .foregroundColor(Colors.primary)
        .baselineOffset(5)
    
    public static let em = Style("em")
        .font(.boldSystemFont(ofSize: 17))
        .foregroundColor(Colors.primary)
    
    public static let strong = Style("strong")
        .font(.boldSystemFont(ofSize: 17))
        .foregroundColor(Colors.primary)
    
    /// Link de hacia una imagen
    public static let aimg = Style("aimg")
        .font(.boldSystemFont(ofSize: 12))
        .foregroundColor(Colors.primary)
        .underlineStyle(.styleSingle)
    
    /// Emboltorio de un bloque de codigo
    public static let div = Style("div")//.paragraphStyle(parag)
    
    /// Bloque de codigo
    public static let pre = Style("pre")
        .backgroundColor(#colorLiteral(red: 0.9137254902, green: 0.9215686275, blue: 0.937254902, alpha: 1))
        .paragraphStyle(NSMutableParagraphStyle().then {
            $0.headIndent = 5
            $0.firstLineHeadIndent = 5
            $0.tailIndent = -5
        })
    
    /// Bloque paragrafo
    public static let p = Style("p")
        .baselineOffset(5)
    
    /// Fotter para indicar al usuario que no hay mas contenido
    public static let final = Style("final")
        .baselineOffset(5)
        .font(.boldSystemFont(ofSize: 10))
        .foregroundColor(Colors.primary.withAlphaComponent(0.6))

    public class func parse(html input: String, addFooter: Bool = false) -> NSAttributedString {

        var html = input
        var descriptionText: NSAttributedString!
        var attachments: [String: String] = [:]

        // Se reemplazan las etiquetas de imagenes
        while let img = html.substring(between: "<img", and: "/>") {
            let alt = img.substring(between: "alt=\"", and: "\" ", includeBrackets: false).or(else: "Attached")!
            let src = img.substring(between: "src=\"", and: "\" ", includeBrackets: false).orEmpty
            let key = "<aimg>IMG-\(alt)</aimg>"

            attachments["IMG-\(alt)"] = "\(src)?IMG"
            html = html.replacingOccurrences(of: img, with: "\n\(key)\n")
        }

        let find = addFooter ? "\n<final>Final del contenido</final> \n\n\n\n" : ""

        descriptionText = "\(html)\(find)".style(tags: [em, strong, p, final, aimg, h3, pre])
            .styleAll(Style.font(.systemFont(ofSize: 14)))
            .attributedString

        let mutable = NSMutableAttributedString(attributedString: descriptionText)
        let finalString = descriptionText.string

        /// add links
        for attach in attachments {
            let range = finalString.range(of: attach.key)
            let nsRange = NSRange.init(range!, in: finalString)
            mutable.addAttribute(.link, value: attach.value, range: nsRange)
        }
        return mutable
    }

}
