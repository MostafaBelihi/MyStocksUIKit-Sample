//
//  NewsItemCell.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 12/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class NewsItemCell: BaseTableViewCell {

	// MARK: - Controls
	@IBOutlet weak var lblNewsTitle: UILabel!
	
	// MARK: - Init
	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupStyle();
	}
	
	func config(newsTitle: String) {
		// Set view data
		setData(newsTitle: newsTitle);
	}

}

// MARK: - View
extension NewsItemCell {
	private func setupStyle() {
		contentView.backgroundColor = AppColor.viewBackgroundSecondary;
		let back = UIView();
		back.backgroundColor = .clear;
		selectedBackgroundView = back;
	}
	
	private func setData(newsTitle: String) {
		lblNewsTitle.text = newsTitle;
	}
}
