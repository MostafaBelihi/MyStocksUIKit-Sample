//
//  StocksListVC.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 11/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class StocksListVC: BaseViewController {

	// MARK: - Dependencies
	private var presenter: PStocksListPresenter!
	private var router: PMainRouter!
	private var di: PDependencyInjector!

	// MARK: - Controls
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var lblNoData: UILabel!

	var btnAdd: UIBarButtonItem?;
	var btnEdit: UIBarButtonItem?;
	var btnDone: UIBarButtonItem?;

	// MARK: - More Variables
	var didShowErrors = false;		// show errors from cells only once

	// MARK: - Init
	init(presenter: PStocksListPresenter, router: PMainRouter, di: PDependencyInjector) {
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

		presenter.delegate = self;

		setupBarButtons();
		setupTableView();

		// Data
		fetchData();
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Deselect table when back
		if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
			self.tableView.deselectRow(at: selectionIndexPath, animated: false);
		}
		
		// Reset errors when view appears
		resetErrors();
	}

}

// MARK: - Data
extension StocksListVC: DataFetchCompletionDelegate, AddStockDelegate {
	/// Fetch data.
	private func fetchData() {
		showIndicator();
		presenter.fetchData();
	}
	
	func didCompleteFetching(completionReturn: [Int]?) {
		hideIndicator();

		tableView.reloadData();
		impactListStatus();
	}
	
	// TODO: This method handles only ErrorType, not an explicit error message.
	func didFailDataFetch(withType errorType: ErrorType) {
		hideIndicator();
		handleError(message: nil, errorType: errorType);
	}
	
	func add(item: CompanyStock) {
		presenter.addStock(item: item) { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			if (isSucess) {
				self.tableView.insertRows(at: [IndexPath(row: self.presenter.items.count - 1, section: 0)], with: .automatic);
				self.impactListStatus();
			}
			else {
				self.handleError(message: message, errorType: errorType);
			}
		}
	}
	
	private func updateOrder(from indexFrom: Int, to indexTo: Int) {
		presenter.updateOrder(from: indexFrom, to: indexTo) { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			if (!isSucess) {
				self.handleError(message: message, errorType: errorType);
			}
		}
	}
	
	private func delete(atIndex index: Int) {
		presenter.deleteStock(atIndex: index) { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			if (isSucess) {
				self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic);
				self.impactListStatus();
			}
			else {
				self.handleError(message: message, errorType: errorType);
			}
		}
	}
	
	private func impactListStatus() {
		tableView.isHidden = (presenter.count == 0);
		lblNoData.isHidden = (presenter.count > 0);
	}
	
	private func handleError(message: String?, errorType: ErrorType?){
		//- Error Handling: No connection - If causes a service failure
		if (errorType == .noConnection) {
			showNoConnectionMessage();
			return;
		}
		
		//- Error Handling: Fetch error
		let errorMessage = message != nil ? message : errorType?.localizedMessage;
		alert.info(message: errorMessage ?? ErrorType.unknownError.localizedMessage);
	}
}

// MARK: - TableView
extension StocksListVC: UITableViewDataSource, UITableViewDelegate {
	func setupTableView() {
		// Register Cell
		di.getStockItemCellType().register(with: tableView);

		// Delegation
		tableView.dataSource = self;
		tableView.delegate = self;
		
		// Refresh
		let refreshControl = UIRefreshControl();
		refreshControl.addTarget(self, action:  #selector(reload), for: .valueChanged);
		refreshControl.tintColor = .white;
		tableView.refreshControl = refreshControl;
		
		// Attributes
		tableView.tableHeaderView = UIView();
		tableView.tableFooterView = UIView();
		tableView.estimatedRowHeight = 100;
		tableView.rowHeight = UITableView.automaticDimension;
		tableView.backgroundColor = AppColor.viewBackgroundPrimary;
		tableView.isHidden = false;
	}
	
	@objc func reload() {
		tableView.reloadData();
		tableView.refreshControl?.endRefreshing();
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
		let item = presenter.items[indexPath.row];
		let cell = di.makeStockItemCell(from: tableView, for: indexPath, with: item);
		cell.delegate = self;
		return cell;
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension;
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		router.viewStockDetails(from: self, item: presenter.items[indexPath.row]);
	}
	
	// Reordering
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true;
	}
	
	// Reordering action
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		updateOrder(from: sourceIndexPath.row, to: destinationIndexPath.row);
	}
	
	// Swipe actions
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		// Delete action
		let delete = UIContextualAction(style: .destructive,
										title: Localizables.delete.text) { [weak self] (action, view, completionHandler) in
			guard let self = self else { return }
			self.delete(atIndex: indexPath.row);
			completionHandler(true);
		}
		
		delete.backgroundColor = .systemRed;
		let configuration = UISwipeActionsConfiguration(actions: [delete]);
		
		return configuration
	}
}

// MARK: - EmitErrorDelegate
extension StocksListVC: EmitErrorDelegate {
	func emitError(message: String) {
		if (!didShowErrors) {
			alert.info(message: message);
			didShowErrors = true;
		}
	}
	
	func emitDisconnectedError() {
		showNoConnectionMessage();
	}

	func resetErrors() {
		didShowErrors = false;
	}
}

	// MARK: - Nav Buttons
extension StocksListVC {
	private func setupBarButtons() {
		btnAdd = UIBarButtonItem(title: Localizables.add.text, style: .plain, target: self, action: #selector(didTapAdd(_:)));
		btnEdit = UIBarButtonItem(title: Localizables.edit.text, style: .plain, target: self, action: #selector(didTapEdit(_:)));
		btnDone = UIBarButtonItem(title: Localizables.done.text, style: .plain, target: self, action: #selector(didTapDone(_:)));
		
		setNormalBarButtons();
	}
	
	private func setNormalBarButtons() {
		self.navigationItem.setRightBarButtonItems([btnEdit!], animated: true);
		self.navigationItem.setLeftBarButtonItems([btnAdd!], animated: true);
	}

	private func setEditingBarButtons() {
		self.navigationItem.setRightBarButtonItems([btnDone!], animated: true);
		self.navigationItem.setLeftBarButtonItems([], animated: true);
	}

	@IBAction func didTapAdd(_ sender: UIBarButtonItem) {
		router.viewAddStock(from: self, delegate: self);
	}

	@IBAction func didTapEdit(_ sender: UIBarButtonItem) {
		setEditingBarButtons();
		tableView.setEditing(true, animated: true);
	}

	@IBAction func didTapDone(_ sender: UIBarButtonItem) {
		setNormalBarButtons();
		tableView.setEditing(false, animated: true);
	}
}
