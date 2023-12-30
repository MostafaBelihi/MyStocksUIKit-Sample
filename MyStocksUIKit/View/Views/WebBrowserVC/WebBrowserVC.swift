//
//  StockNewsVC.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 14/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit
import WebKit

class WebBrowserVC: UIViewController {
	
	// MARK: - Controls
	@IBOutlet weak var webView: WKWebView!
	var urlString: String?
	
	// MARK: - Init
	init(urlString: String) {
		self.urlString = urlString;

		super.init(nibName: "\(Self.self)", bundle: nil);
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if let url = urlString {
			webView.load(url);
			setupBarButtons();
		}
    }
	
	// MARK: - Nav Buttons
	func setupBarButtons() {
		let btn1 = UIBarButtonItem(title: "Open in Safari", style: .plain, target: self, action: #selector(navBtn1DidTouch(_:)));
		self.navigationItem.setRightBarButtonItems([btn1], animated: false);
	}
	
	@IBAction func navBtn1DidTouch(_ sender: UIBarButtonItem) {
		if let url = URL(string: urlString!) {
			UIApplication.shared.open(url);
		}
	}

}
