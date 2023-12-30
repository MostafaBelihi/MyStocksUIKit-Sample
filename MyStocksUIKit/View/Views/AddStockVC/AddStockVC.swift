//
//  AddStockVC.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 20/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class AddStockVC: BaseViewController {

	// MARK: - Dependencies
	private var presenter: PAddStockPresenter!
	private var di: PDependencyInjector!

	// MARK: - Controls
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var txtSearch: StyleUITextFieldBase!
	@IBOutlet weak var lblNoData: UILabel!

	// MARK: - More Variables
	weak var delegate: AddStockDelegate?

	// MARK: - Init
	init(presenter: PAddStockPresenter, di: PDependencyInjector, delegate: AddStockDelegate?) {
		self.presenter = presenter;
		self.di = di;
		self.delegate = delegate;

		super.init(nibName: "\(Self.self)", bundle: nil);
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter.delegate = self;
		txtSearch.delegate = self;

		setupTableView();

		// Data
		fetchData();
	}
	
	// MARK: - Events
	@IBAction func didTouchCancel(_ sender: Any) {
		dismiss(animated: true, completion: nil);
	}
	
	@IBAction func didChangeSearch(_ sender: Any) {
		if let filterValue = txtSearch.text?.lowercased()
		{
			presenter.filter(with: filterValue);
			tableView.reloadData();
		}
	}

}

extension AddStockVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
		self.dismissKeyboard();
		return true;
	}
}

// MARK: - Data
extension AddStockVC: DataFetchCompletionDelegate {
	/// Fetch data.
	private func fetchData() {
		showIndicator();
		presenter.fetchData();
	}
	
	func didCompleteFetching(completionReturn: [Int]?) {
		hideIndicator();

		tableView.reloadData();
		tableView.isHidden = (presenter.count == 0);
		lblNoData.isHidden = (presenter.count > 0);
	}
	
	// TODO: This method handles only ErrorType, not an explicit error message.
	func didFailDataFetch(withType errorType: ErrorType) {
		hideIndicator();

		//- Error Handling: No connection - If causes a service failure
		if (errorType == .noConnection) {
			showNoConnectionMessage();
			return;
		}
		
		//- Error Handling: Fetch error
		alert.info(message: errorType.localizedMessage);
	}
}

// MARK: - TableView
extension AddStockVC: UITableViewDataSource, UITableViewDelegate {
	func setupTableView() {
		// Register Cell
		di.getExchangeItemCellType().register(with: tableView);

		// Delegation
		tableView.dataSource = self;
		tableView.delegate = self;
		
		// Attributes
		tableView.tableHeaderView = UIView();
		tableView.tableFooterView = UIView();
		tableView.estimatedRowHeight = 100;
		tableView.rowHeight = UITableView.automaticDimension;
		tableView.backgroundColor = AppColor.viewBackgroundPrimary;
		tableView.separatorColor = AppColor.textPrimary;
		tableView.isHidden = false;
	}
	
	// numberOfSections
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	
	// numberOfRowsInSection
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.count;
	}

	// View content in cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = presenter.filteredItems[indexPath.row];
		let cell = di.makeExchangeItemCell(from: tableView, for: indexPath, with: "\(item.name ?? "") (\(item.symbol))");
		return cell;
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension;
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dismiss(animated: true, completion: nil);
		delegate?.add(item: presenter.filteredItems[indexPath.row]);
	}
}

protocol AddStockDelegate : AnyObject {
	func add(item: CompanyStock);
}
