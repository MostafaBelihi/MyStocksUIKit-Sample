//
//  StockDetailsVC.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 05/12/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit
import Charts

class StockDetailsVC: BaseViewController {

	// MARK: - Dependencies
	private var presenter: PStockDetailsPresenter!
	private var router: PMainRouter!
	private var di: PDependencyInjector!

	// MARK: - Controls
	@IBOutlet weak var viewContent: UIView!
	
	// Company
	@IBOutlet weak var lblCompanyName: UILabel!
	@IBOutlet weak var lblStockSymbol: UILabel!
	
	// Stock Status
	@IBOutlet weak var lblPrice: UILabel!
	@IBOutlet weak var lblPercentage: UILabel!

	// Stock Stats
	@IBOutlet weak var lblOpen: UILabel!
	@IBOutlet weak var lblHigh: UILabel!
	@IBOutlet weak var lblLow: UILabel!
	@IBOutlet weak var lblVol: UILabel!
	@IBOutlet weak var lblMarketCap: UILabel!
	@IBOutlet weak var lbl52WH: UILabel!
	@IBOutlet weak var lbl52WL: UILabel!
	@IBOutlet weak var lblAvgVol: UILabel!
	
	// Chart
	@IBOutlet weak var segmentedChart: UISegmentedControl!
	@IBOutlet weak var viewSegmentedChart: UILabel!
	@IBOutlet weak var viewChart: LineChartView!		// LineChartView
	let buttonBar = UIView()
	@IBOutlet weak var indicator: UIActivityIndicatorView!
	@IBOutlet weak var lblNoData: StyleUILabelNormalText!

	// News
	@IBOutlet weak var viewNews: UIView!
	@IBOutlet weak var tblNews: UITableView!
	@IBOutlet weak var constraintViewNewsHeight: NSLayoutConstraint!
	var initViewNewsHeight: CGFloat?
	@IBOutlet weak var btnMoreNews: UIButton!
	
	// MARK: - More Variables
	let serviceCallsCount = 5;
	var serviceCallsDone = 0;
	
	// MARK: - Init
	init(presenter: PStockDetailsPresenter, router: PMainRouter, di: PDependencyInjector) {
		self.presenter = presenter;
		self.router = router;
		self.di = di;
		
		super.init(nibName: "\(Self.self)", bundle: nil);
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		setupScrollView(contentView: viewContent);

		super.viewDidLoad()

		initViewNewsHeight = constraintViewNewsHeight.constant;

		// Fetch data
		fetchData();
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Deselect table when back
		if let selectionIndexPath = self.tblNews.indexPathForSelectedRow {
			self.tblNews.deselectRow(at: selectionIndexPath, animated: false);
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated);
		
		if let news = presenter.news, news.count > 0 {
			constraintViewNewsHeight.constant = initViewNewsHeight! + tblNews.contentSize.height;
		}
	}

	// MARK: - Events
	@IBAction func segmentedControlValueChanged(_ sender: Any) {
		UIView.animate(withDuration: 0.3) {
			self.buttonBar.frame.origin.x = (self.segmentedChart.frame.width / CGFloat(self.segmentedChart.numberOfSegments)) * CGFloat(self.segmentedChart.selectedSegmentIndex);
		}
		
		switch segmentedChart.selectedSegmentIndex {
			case 0:
				fetchChartData(for: .week);

			case 1:
				fetchChartData(for: .month);

			case 2:
				fetchChartData(for: .year);

			default:
				return;
		}
	}
	
	@IBAction func btnMoreNewDidTouch(_ sender: Any) {
		router.viewStockNews(from: self, stock: presenter.stock, stockStatus: presenter.stockStatus, news: presenter.news);
	}

}

// MARK: - Data
extension StockDetailsVC {
	private func fetchData() {
		presenter.fetchStockStatus { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			self.serviceCallsDone += 1;
			
			if (isSucess) {
				self.setStockStatus();
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
			}
			else {
				self.setCompanyData();
				self.handleError(message: message, errorType: errorType);
			}
		}

		presenter.fetchStockStats { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			self.serviceCallsDone += 1;
			
			if (isSucess) {
				self.setStockStats();
			}
			else {
				self.handleError(message: message, errorType: errorType);
			}
		}

		presenter.fetchNews { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			self.serviceCallsDone += 1;
			
			if (isSucess) {
				self.setNews();
			}
			else {
				self.handleError(message: message, errorType: errorType);
			}
		}
		
		fetchChartData(for: .week);
	}
	
	private func fetchChartData(for period: ChartPeriod) {
		startLoadingChart();
		// Get data
		presenter.fetchChartData(for: period) { [weak self] isSucess, message, errorType in
			guard let self = self else { return }
			self.serviceCallsDone += 1;
			
			if (isSucess) {
				// setupChart
				self.setupChart(for: period);
				self.stopLoadingChart();
			}
			else {
				self.stopLoadingChart();
				self.handleError(message: message, errorType: errorType);
			}
		}
	}
	
	private func handleError(message: String?, errorType: ErrorType?){
		//- Error Handling: No connection - If causes a service failure
		if (errorType == .noConnection) {
			showNoConnectionMessage();
			return;
		}
		
		//- Error Handling: Fetch error
		if (serviceCallsDone >= serviceCallsCount) {
			let errorMessage = message != nil ? message : errorType?.localizedMessage;
			alert.info(message: errorMessage ?? ErrorType.unknownError.localizedMessage);
		}
	}
}

// MARK: - View
extension StockDetailsVC {
	private func setStockStatus() {
		lblPrice.text = presenter.price ?? Localizables.empty.text;
		lblPercentage.text = presenter.percentage ?? Localizables.empty.text;
		lblOpen.text = presenter.open;
		lblHigh.text = presenter.high;
		lblLow.text = presenter.low;
		
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
		lblStockSymbol.text = presenter.symbol;
		lblCompanyName.text = presenter.companyName ?? Localizables.empty.text;
		lblMarketCap.text = presenter.marketCap ?? Localizables.empty.text;
	}
	
	private func setStockStats() {
		lblVol.text = presenter.volume ?? Localizables.empty.text;
		lbl52WH.text = presenter.highOf52Weeks ?? Localizables.empty.text;
		lbl52WL.text = presenter.lowOf52Weeks ?? Localizables.empty.text;
		lblAvgVol.text = presenter.averageVolume ?? Localizables.empty.text;
	}
	
	private func setNews() {
		if let news = presenter.news, news.count > 0 {
			self.setupTableView();
			self.viewNews.isHidden = false;
		}
	}
}

// MARK: - Chart
extension StockDetailsVC {
	private func startLoadingChart() {
		indicator.isHidden = false;
		viewChart.isHidden = true;
		lblNoData.isHidden = true;
	}
	
	private func stopLoadingChart() {
		indicator.isHidden = true;
		viewChart.isHidden = presenter.chartDataEntries.count == 0;
		lblNoData.isHidden = presenter.chartDataEntries.count > 0;
	}
	
	private func setupChart(for period: ChartPeriod) {
		// Line data
		let line = LineChartDataSet(entries: presenter.chartDataEntries, label: "");
		
		// Line style and attributes
		line.lineWidth = 0.0;
		line.drawCirclesEnabled = false;
		line.drawValuesEnabled = false;
		line.fillColor = AppColor.chartFill;
		line.drawFilledEnabled = true;
		line.drawHorizontalHighlightIndicatorEnabled = false;
		line.drawVerticalHighlightIndicatorEnabled = false;
		
		// Chart data
		let chartData = LineChartData(dataSet: line);
		let format = NumberFormatter();
		format.numberStyle = .none;
		let formatter = DefaultValueFormatter(formatter: format);
		chartData.setValueFormatter(formatter);
		self.viewChart.data = chartData;
		
		// Chart style and attributes
		self.viewChart.legend.enabled = false;
		
		self.viewChart.xAxis.labelFont = TextStyle.tiny.font;
		self.viewChart.xAxis.labelPosition = .bottom;
		self.viewChart.xAxis.labelTextColor = .white;
		self.viewChart.xAxis.drawAxisLineEnabled = false;
		self.viewChart.xAxis.drawGridLinesEnabled = false;
		self.viewChart.xAxis.valueFormatter = period.dateValueFormatter;
		
		self.viewChart.leftAxis.labelFont = TextStyle.tiny.font;
		self.viewChart.leftAxis.labelTextColor = .white;
		self.viewChart.leftAxis.drawAxisLineEnabled = false;
		self.viewChart.leftAxis.drawGridLinesEnabled = false;
		
		self.viewChart.rightAxis.enabled = false;
		
		self.viewChart.pinchZoomEnabled = false;
		self.viewChart.doubleTapToZoomEnabled = false;
		self.viewChart.dragEnabled = true;
		self.viewChart.setScaleEnabled(true);
	}
}

// MARK: - TableView
extension StockDetailsVC: UITableViewDataSource, UITableViewDelegate {
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
		let maxNewsCount = 3;
		
		if let count = presenter.news?.count {
			if (count > maxNewsCount) {
				self.btnMoreNews.isHidden = false;
				return maxNewsCount;
			}
			else {
				return count;
			}
		}
		else {
			return 0;
		}
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
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		constraintViewNewsHeight.constant = initViewNewsHeight! + tblNews.contentSize.height;
		
		let viewFooter = UIView();
		viewFooter.bounds = CGRect(x: 0,y: 0,width: 0,height: 0);

		return viewFooter;
	}
}

extension ChartPeriod {
	var dateValueFormatter: AxisValueFormatter {
		switch self {
			case .week: 	return WeekDateValueFormatter();
			case .month: 	return MonthDateValueFormatter();
			case .year: 	return YearDateValueFormatter();
		}
	}
}
