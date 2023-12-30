//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

// MARK: - UIViewController
class StyleUIViewControllerBase: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
		view.backgroundColor = AppColor.viewBackgroundPrimary;
	}
}

// MARK: - UIView
class StyleUIViewBase: UIView {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
		backgroundColor = AppColor.viewBackgroundPrimary;
	}
}

// MARK: - UILabel
class StyleUILabelBase: UILabel {
	override func awakeFromNib() {
		super.awakeFromNib()

		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
		font = TextStyle.normal.font;
		textColor = AppColor.textPrimary;
	}
}

// MARK: - UIButton
class StyleUIButtonBase: UIButton {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
		tintColor = AppColor.tintPrimary;
		titleLabel?.font = TextStyle.normal.font;
	}
}

// MARK: - UIImageView
class StyleUIImageViewBase: UIImageView {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
	}
}

// MARK: - UITextField
class StyleUITextFieldBase: UITextField {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
		font = TextStyle.normal.font;
	}
}

// MARK: - UISegmentedControl
class StyleUISegmentedControlBase: UISegmentedControl {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		applyStyles();
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		applyStyles();
	}
	
	func applyStyles() {
	}
}
