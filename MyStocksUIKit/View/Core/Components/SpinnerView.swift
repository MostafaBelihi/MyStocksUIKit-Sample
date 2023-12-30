//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class SpinnerView: UIView {
	private lazy var indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func config(indicatorColor: UIColor?, backgroundColor: UIColor?) {
		if let indicatorColor = indicatorColor {
			indicator.color = indicatorColor;
		}

		if let backgroundColor = backgroundColor {
			indicator.backgroundColor = backgroundColor;
		}
	}
	
	private func commonInit() {
		if #available(iOS 13.0, *) {
			indicator.style = .large;
		} else {
			// Fallback on earlier versions
		}

		// View
		translatesAutoresizingMaskIntoConstraints = false;
		
		// Activity Indicator
		indicator.translatesAutoresizingMaskIntoConstraints = false;
		self.addSubview(indicator);
		
		NSLayoutConstraint.activate([
			indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			indicator.widthAnchor.constraint(equalToConstant: 100),
			indicator.heightAnchor.constraint(equalToConstant: 100)
		])

		// We use a 0.5 second delay to not show an activity indicator
		// in case our data loads very quickly.
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			self?.indicator.startAnimating()
		}
	}
}
