//
//  IssueTableViewCell.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Atributika
import SwipeCellKit

public class IssueTableViewCell: SwipeTableViewCell {

	@IBOutlet weak private var idLabel: UILabel!
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var descriptionLabel: UILabel!

	@IBOutlet weak var avatar: UIImageView!

	public var issue: Issue? {
		didSet {
			idLabel.text = "#\(issue?.id ?? 0)"
			titleLabel.text = issue?.title

			avatar.setImage(fromURL: issue?.assignee?.avatar)
            
            let xml = NSMutableString()
            
            var stateStyle = Style("state").font(.boldSystemFont(ofSize: 12))
            
			// Segun el estado en que se encuentre el issue se fija un color diferente
			if let state = issue?.state {
                xml.append("<state>")
                xml.append(state.rawValue)
                xml.append("</state>")
                stateStyle = stateStyle.foregroundColor(state.color)
			}
            
            // El nombre de la persona aignada
            xml.append(" • ")
            xml.append((issue?.assignee?.displayName).orEmpty)
            xml.append(" • ")
            
            // La fecha de ultima modificacion
            xml.append((issue?.updatedOn ?? issue!.createdOn!).relativeTime)

            descriptionLabel.attributedText = xml.description.style(tags: [stateStyle]).attributedString
		}

	}
}
