//
//  UIButtonStyles.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 21/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class StyleUIButtonLink: StyleUIButtonBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		titleLabel?.font = TextStyle.small.font;
		titleLabel?.attributedText =
			NSAttributedString(string: "Text", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]);
	}
}
