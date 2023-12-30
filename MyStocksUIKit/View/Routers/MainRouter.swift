//
//  MainRouter.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 12/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

protocol PMainRouter {
	func viewStockDetails(from sourceView: UIViewController, item: CompanyStock);
	func viewStockNews(from sourceView: UIViewController,
					   stock: CompanyStock,
					   stockStatus: StockStatus?,
					   news: [CompanyNews]?);
	func viewWebBrowser(from sourceView: UIViewController, urlString: String);
	func viewAddStock(from sourceView: UIViewController, delegate: AddStockDelegate?);
}

class MainRouter: PMainRouter {
	
	// MARK: - Dependencies
	private var di: PDependencyInjector;
	
	// MARK: - Init
	init(di: PDependencyInjector) {
		self.di = di;
	}
	
	// MARK: - Functions
	func viewStockDetails(from sourceView: UIViewController, item: CompanyStock) {
		let vc = di.makeStockDetailsVC(with: item);
		sourceView.navigationController?.pushViewController(vc, animated: true);
	}
	
	func viewStockNews(from sourceView: UIViewController,
					   stock: CompanyStock,
					   stockStatus: StockStatus?,
					   news: [CompanyNews]?) {
		
		let vc = di.makeStockNewsVC(stock: stock, stockStatus: stockStatus, news: news);
		sourceView.navigationController?.pushViewController(vc, animated: true);
	}
	
	func viewWebBrowser(from sourceView: UIViewController, urlString: String) {
		let vc = di.makeWebBrowserVC(urlString: urlString);
		sourceView.navigationController?.pushViewController(vc, animated: true);
	}
	
	func viewAddStock(from sourceView: UIViewController, delegate: AddStockDelegate?) {
		let vc = di.makeAddStockVC(delegate: delegate);
		sourceView.present(vc, animated: true);
	}

}
