//
//  StockItemCell.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 13/11/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit

class StockItemCell: BaseTableViewCell {

	// MARK: - Dependencies
	private var presenter: PStockItemCellPresenter!
	
	// MARK: - Controls
	@IBOutlet weak var lblSymbol: UILabel!
	@IBOutlet weak var lblCompanyName: UILabel!
	@IBOutlet weak var lblMarketCap: UILabel!
	@IBOutlet weak var lblPrice: UILabel!
	@IBOutlet weak var lblPercentage: UILabel!

	// MARK: - More Variables
	let serviceCallsCount = 2;
	var serviceCallsDone = 0;

	// MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
		setupStyle();
    }

	func inject(presenter: PStockItemCellPresenter) {
		self.presenter = presenter;
	}
	
	func config() {
		// Set view data
		setData();

		// Load more data
		fetchData();
	}

	// MARK: - Events

}

// MARK: - Data
extension StockItemCell {
	private func fetchData() {
		presenter.fetchStockStatus { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			self.serviceCallsDone += 1;
			
			if (isSucess) {
				self.setStockStatus();
				self.delegate?.resetErrors();
			}
			else {
				self.handleError(message: message, errorType: errorType);
			}
		}
		
		presenter.fetchCompany { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			self.serviceCallsDone += 1;
			
			if (isSucess) {
				self.setCompanyData();
				self.delegate?.resetErrors();
			}
			else {
				self.handleError(message: message, errorType: errorType);
			}
		}
	}
	
	private func handleError(message: String?, errorType: ErrorType?){
		//- Error Handling: No connection - If causes a service failure
		if (errorType == .noConnection) {
			delegate?.emitDisconnectedError();
			return;
		}
		
		//- Error Handling: Fetch error
		if (serviceCallsDone >= serviceCallsCount) {
			let errorMessage = message != nil ? message : errorType?.localizedMessage;
			self.delegate?.emitError(message: errorMessage ?? ErrorType.unknownError.localizedMessage);
		}
	}
}

// MARK: - View
extension StockItemCell {
	private func setupStyle() {
		backgroundColor = AppColor.viewBackgroundSecondary;
		
		let back = UIView();
		back.backgroundColor = .clear;
		selectedBackgroundView = back;
		
		self.lblPrice.textColor = .white;
		self.lblPercentage.textColor = .white;
	}
	
	private func resetData() {
		self.lblPrice.textColor = .white;
		self.lblPercentage.textColor = .white;
	}
	
	private func setData() {
		lblSymbol.text = presenter.symbol;
	}

	private func setStockStatus() {
		lblPrice.text = presenter.price;
		lblPercentage.text = presenter.percentage;

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
		lblCompanyName.text = presenter.companyName;
		lblMarketCap.text = presenter.marketCap;
	}
}
