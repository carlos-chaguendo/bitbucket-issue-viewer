//
//  Bool.swift
//  Core
//
//  Created by Carlos Chaguendo on 12/06/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

public extension Bool {

	/// Intercambia el valor existende
	public mutating func toogle() {
		self = !self
	}

	/// Retorna el valor existente intercambiado
	public var toggled: Bool {
		return !self
	}

}
