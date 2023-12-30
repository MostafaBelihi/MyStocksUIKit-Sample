//
//  UILabelStyles.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 20/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class StyleUILabelTableHeader: StyleUILabelBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		font = AppFont(size: TextStyle.normal.fontSize, weight: .semibold).font;
		textColor = AppColor.textSecondary;
	}
}

// MARK: - Text
class StyleUILabelNormalText: StyleUILabelBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		font = AppFont(size: TextStyle.normal.fontSize, weight: .semibold).font;
	}
}

class StyleUILabelNormalSecondaryText: StyleUILabelNormalText {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		textColor = AppColor.textSecondary;
	}
}

class StyleUILabelSubText: StyleUILabelBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		font = AppFont(size: TextStyle.tiny.fontSize, weight: .semibold).font;
	}
}

class StyleUILabelSubSecondaryText: StyleUILabelSubText {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		textColor = AppColor.textSecondary;
	}
}

// MARK: - Details Header
class StyleUILabelHeader: StyleUILabelBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		font = AppFont(size: TextStyle.large.fontSize, weight: .semibold).font;
	}
}

class StyleUILabelSubHeader: StyleUILabelBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		font = AppFont(size: TextStyle.medium.fontSize, weight: .bold).font;
	}
}

class StyleUILabelSubSecondaryHeader: StyleUILabelSubHeader {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		textColor = AppColor.textSecondary;
	}
}

class StyleUILabelModalHeader: StyleUILabelBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	override func applyStyles() {
		super.applyStyles();
		
		font = TextStyle.medium.font;
	}
}

// MARK: - Stock Values
class StyleUILabelStockListPrice: UILabel {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
		font = AppFont(size: TextStyle.normal.fontSize, weight: .semibold).font;
	}
}

class StyleUILabelStockListPercentage: UILabel {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
		font = AppFont(size: TextStyle.tiny.fontSize, weight: .semibold).font;
	}
}

class StyleUILabelStockDetailsPrice: UILabel {
	override func awakeFromNib() {
		super.awakeFromNib()

		applyStyles();
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}

	func applyStyles() {
		font = AppFont(size: TextStyle.large.fontSize, weight: .semibold).font;
	}
}

class StyleUILabelStockDetailsPercentage: UILabel {
	override func awakeFromNib() {
		super.awakeFromNib()

		applyStyles();
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}

	func applyStyles() {
		font = AppFont(size: TextStyle.medium.fontSize, weight: .bold).font;
	}
}
