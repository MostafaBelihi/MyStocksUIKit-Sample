//
//  ExchangeItemCell.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 20/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class ExchangeItemCell: BaseTableViewCell {

	@IBOutlet weak var lblText: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		backgroundColor = AppColor.viewBackgroundPrimary;
	}
	
	func setText(_ text: String) {
		lblText.text = text;
	}
	
}
