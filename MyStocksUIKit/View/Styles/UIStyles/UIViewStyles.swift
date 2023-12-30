//
//  UIViewStyles.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 20/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class StyleUIViewSecondaryFill: StyleUIViewBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		backgroundColor = AppColor.viewBackgroundSecondary;
	}
}

class StyleUIViewDetailSection: StyleUIViewBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		addBorders(edges: .bottom, color: AppColor.getColor(fromHex: "282828"), width: 1.0);
	}
}
