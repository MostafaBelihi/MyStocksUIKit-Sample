//
//  StyleUISegmentedControlChart.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 13/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class StyleUISegmentedControlChart : StyleUISegmentedControlBase {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// Add lines below selectedSegmentIndex
		backgroundColor = .clear;
		if #available(iOS 13.0, *) {
			selectedSegmentTintColor = AppColor.getColor(fromHex: "3E3E3E");
		} else {
			tintColor = .clear;
		}
		
		// Add lines below the segmented control's tintColor
		setTitleTextAttributes([
			NSAttributedString.Key.font : TextStyle.normal.font,
			NSAttributedString.Key.foregroundColor: AppColor.tintSecondary
		], for: .normal);
		
		setTitleTextAttributes([
			NSAttributedString.Key.font : TextStyle.normal.font,
			NSAttributedString.Key.foregroundColor: AppColor.tintPrimary
		], for: .selected);
		
	}
}
