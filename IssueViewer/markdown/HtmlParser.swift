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

	public static let aissue = Style("aissue")
		.font(.boldSystemFont(ofSize: 12))
		.foregroundColor(Colors.primary)
		.underlineStyle(.styleSingle)

	/// Emboltorio de un bloque de codigo
	public static let div = Style("div").backgroundColor(#colorLiteral(red: 0.9137254902, green: 0.9215686275, blue: 0.937254902, alpha: 1))

	/// Bloque de codigo
	public static let pre = Style("pre")
	//.backgroundColor(#colorLiteral(red: 0.9137254902, green: 0.9215686275, blue: 0.937254902, alpha: 1))
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

	/// texto tachado
	public static let del = Style("del").strikethroughStyle(.styleSingle)

	/// Comentario o referencia >
	public static let blockquote = Style("blockquote").backgroundColor(#colorLiteral(red: 0.9764705896, green: 0.8783940377, blue: 0.4929561395, alpha: 0.4355948044))


	public static let tr = Style("tr")
		.underlineStyle(.styleSingle)

	/// codigo en una sola linea
	public static let code = Style("code")
		.backgroundColor(#colorLiteral(red: 0.9137254902, green: 0.9215686275, blue: 0.937254902, alpha: 1))

	public class func parse(html input: String, addFooter: Bool = false, includeAttach: Bool = true) -> NSAttributedString {

		var html = input
		var descriptionText: NSAttributedString!
		var attachments: [String: String] = [:]
		var tables: [String: NSAttributedString] = [:]


		// Se reemplazan las etiquetas de imagenes
		while let img = html.substring(between: "<img", and: "/>") {
			let alt = img.substring(between: "alt=\"", and: "\" ", includeBrackets: false).or(else: "Attached")!
			let src = img.substring(between: "src=\"", and: "\" ", includeBrackets: false).orEmpty
			let key = "<aimg>IMG-\(alt)</aimg>"

			attachments["IMG-\(alt)"] = "\(src)?img"
			html = html.replacingOccurrences(of: img, with: "\n\(key)\n")
		}


		while let img = html.substring(between: "<a ", and: "</a>") {
			var href = img.substring(between: "href=\"", and: "\" ", includeBrackets: false).or(else: "Attached")!
			var title = img.substring(between: "title=\"", and: "\"", includeBrackets: false).orEmpty
			var key = title

			/// los links hacia los issues
			if let issueKey = img.substring(between: "<s>", and: "</s>", includeBrackets: false) {
				title = "\(issueKey)-\(title) →"
				href = "\(href)?issue-id"
				key = "<aissue>\(title)</<aissue>"
			}


			attachments[title] = href
			html = html.replacingOccurrences(of: img, with: key)
		}


		while let table = html.substring(between: "<table>", and: "/table>"),
			let data = table.data(using: .utf8),
			let tableHtmlAtributed = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {

				let key = "Table-\(tables.count + 1)"
				tables[key] = tableHtmlAtributed
				html = html.replacingOccurrences(of: table, with: "\n\(key)\n")
		}


		let find = addFooter ? "\n<final>Final del contenido</final> \n\n\n\n" : ""

		var tags = [em, strong, p, final, h3, div, pre, del, blockquote, tr, code]

		if includeAttach {
			tags.append(aimg)
			tags.append(aissue)
		}

		descriptionText = "\(html)\(find)".style(tags: tags)
			.styleAll(Style.font(.systemFont(ofSize: 14)))
			.attributedString

		let mutable = NSMutableAttributedString(attributedString: descriptionText)


		let finalString = descriptionText.string


		/// add links
		if includeAttach {
			for attach in attachments where !attach.key.isEmpty {
				let range = finalString.range(of: attach.key)
				let nsRange = NSRange.init(range!, in: finalString)
				mutable.addAttribute(.link, value: attach.value, range: nsRange)
			}
		}


		/// add tables
		for attach in tables {
//            let range = finalString.range(of: attach.key)
//            let nsRange = NSRange.init(range!, in: finalString)
//              mutable.replaceCharacters(in: nsRange, with: attach.value)
			mutable.append(attach.value)
		}

		return mutable
	}

}
