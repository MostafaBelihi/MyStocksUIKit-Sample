//
//  StockNewsVC.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 14/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class StockNewsVC: BaseViewController {

	// MARK: - Dependencies
	private var presenter: PStockNewsPresenter!
	private var router: PMainRouter!
	private var di: PDependencyInjector!

	// MARK: - Controls
	@IBOutlet weak var viewContent: UIView!
	
	// Current
	@IBOutlet weak var lblPrice: UILabel!
	@IBOutlet weak var lblPercentage: UILabel!
	
	// News
	@IBOutlet weak var viewNews: UIView!
	@IBOutlet weak var tblNews: UITableView!

	
	// MARK: - More Variables

	
	// MARK: - Init
	init(presenter: PStockNewsPresenter, router: PMainRouter, di: PDependencyInjector) {
		self.presenter = presenter;
		self.router = router;
		self.di = di;

		super.init(nibName: "\(Self.self)", bundle: nil);
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		setStockStatus();
		setCompanyData();
		setNews();

    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Deselect table when back
		if let selectionIndexPath = self.tblNews.indexPathForSelectedRow {
			self.tblNews.deselectRow(at: selectionIndexPath, animated: false);
		}
	}

}

// MARK: - View
extension StockNewsVC {
	private func setStockStatus() {
		lblPrice.text = presenter.price ?? Localizables.empty.text;
		lblPercentage.text = presenter.percentage ?? Localizables.empty.text;
		
		self.lblPrice.textColor = .white;
		self.lblPercentage.textColor = .white;
		
		if (presenter.stockProgressStatus == .positive) {
			self.lblPrice.textColor = AppColor.numPositive;
			self.lblPercentage.textColor = AppColor.numPositive;
		}
		
		if (presenter.stockProgressStatus == .negative) {
			self.lblPrice.textColor = AppColor.numNegative;
			self.lblPercentage.textColor = AppColor.numNegative;
		}
	}
	
	private func setCompanyData() {
		title = presenter.companyName;
	}
	
	private func setNews() {
		if let news = presenter.news, news.count > 0 {
			self.setupTableView();
			self.viewNews.isHidden = false;
		}
	}
}

// MARK: - TableView
extension StockNewsVC: UITableViewDataSource, UITableViewDelegate {
	func setupTableView() {
		// Register Cell
		di.getNewsItemCellType().register(with: tblNews);

		// Delegation
		tblNews.dataSource = self;
		tblNews.delegate = self;
		
		// Attributes
		tblNews.tableHeaderView = UIView();
		tblNews.tableFooterView = UIView();
		tblNews.estimatedRowHeight = 100;
		tblNews.rowHeight = UITableView.automaticDimension;
		tblNews.backgroundColor = AppColor.viewBackgroundPrimary;
	}
	
	// numberOfSections
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	
	// numberOfRowsInSection
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.news?.count ?? 0;
	}

	// View content in cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = presenter.news![indexPath.row];
		let cell = di.makeNewsItemCell(from: tblNews, for: indexPath, with: item.title);
		return cell;
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension;
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		router.viewWebBrowser(from: self, urlString: presenter.news![indexPath.row].url);
	}
}
