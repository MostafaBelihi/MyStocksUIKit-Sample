//
//  DependencyInjector.swift
//  MyStocksUIKit
//
//  Created by Mostafa AlBelliehy on 28/07/2022.
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import UIKit
import Swinject
import Reachability

protocol PDependencyInjector {
	var container: Container { get }
	
	// MARK: - View Makers - Root
	func makeRootViewController() -> UIViewController;
	
	// MARK: - View Makers - Views
	func makeLanguageSwitcher(completion: @escaping VoidClosure) -> UIViewController;
	func makeSpinnerView(indicatorColor: UIColor?, backgroundColor: UIColor?) -> UIView;

	// MARK: - View Makers - VCs
	func makeStocksListVC() -> UIViewController;
	func makeStockDetailsVC(with item: CompanyStock) -> UIViewController;
	func makeStockNewsVC(stock: CompanyStock, stockStatus: StockStatus?, news: [CompanyNews]?) -> UIViewController;
	func makeWebBrowserVC(urlString: String) -> UIViewController;
	func makeAddStockVC(delegate: AddStockDelegate?) -> UIViewController;

	// MARK: - View Makers - Cells
	func makeStockItemCell(from tableView: UITableView, for indexPath: IndexPath, with item: CompanyStock) -> BaseTableViewCell;
	func getStockItemCellType() -> InjectableTableViewCell.Type;
	
	func makeNewsItemCell(from tableView: UITableView, for indexPath: IndexPath, with newsTitle: String) -> BaseTableViewCell;
	func getNewsItemCellType() -> InjectableTableViewCell.Type;
	
	func makeExchangeItemCell(from tableView: UITableView, for indexPath: IndexPath, with text: String) -> BaseTableViewCell;
	func getExchangeItemCellType() -> InjectableTableViewCell.Type;
}

class DependencyInjector: PDependencyInjector {
	
	var container: Container;
	
	// MARK: - Init
	init() {
		container = Container();
		Container.loggingFunction = nil;
		
		// Register Dependencies
		registerSupport();
		registerDataProviders();
		registerBusiness();
		registerRouters();
		registerPresenters();
		registerViews();
	}
	
	// MARK: - Supportive Layer
	private func registerSupport() {
		container.register(Connectivity.self) { r in
			let instance = ConnectionManager();
			instance.setup(reachability: try! Reachability());
			
			return instance;
		}.inObjectScope(.container);
		
		container.register(Logging.self) { _ in DebugLogger() }.inObjectScope(.container);
		
		container.register(PDataCoder.self) { (r, jsonDecoder: JSONDecoder, jsonEncoder: JSONEncoder) in
			DataCoder(jsonDecoder: jsonDecoder, jsonEncoder: jsonEncoder, logger: r.resolve(Logging.self)!)
		}.inObjectScope(.container);
	}
	
	// MARK: - Data
	private func registerDataProviders() {
		container.register(PDBData.self) { r in
			// Get NSPersistentContainer
			let appDelegate = UIApplication.shared.delegate as? AppDelegate;
			let persistentContainer = appDelegate?.persistentContainer;

			return DBData(logger: r.resolve(Logging.self)!,
						  persistentContainer: persistentContainer)
		}.inObjectScope(.container);
		
		container.register(PNetworkAPIData.self) { r in
			NetworkAPIData(logger: r.resolve(Logging.self)!,
						   dataCoder: r.resolve(PDataCoder.self),
						   connection: r.resolve(Connectivity.self)!)
		}.inObjectScope(.container);
		
		container.register(PDataRequests.self) { r in
			MainDataProvider(dbData: r.resolve(PDBData.self)!, networkAPIData: r.resolve(PNetworkAPIData.self)!)
		}.inObjectScope(.container);
	}
	
	// MARK: - Business
	private func registerBusiness() {
		container.register(PMainBusiness.self) { r in
			MainInteractor(data: r.resolve(PDataRequests.self)!)
		}.inObjectScope(.container);
	}
	
	// MARK: - Routers
	private func registerRouters() {
		container.register(PMainRouter.self) { _ in MainRouter(di: self) }
	}
	
	// MARK: - Presenters
	private func registerPresenters() {
		container.register(PStockItemCellPresenter.self) { (r, item: CompanyStock) in
			StockItemCellPresenter(with: item, interactor: r.resolve(PMainBusiness.self)!)
		}
		
		container.register(PStocksListPresenter.self) { r in StocksListPresenter(interactor: r.resolve(PMainBusiness.self)!) }
		
		container.register(PStockDetailsPresenter.self) { (r, item: CompanyStock) in
			StockDetailsPresenter(with: item, interactor: r.resolve(PMainBusiness.self)!)
		}
		
		container.register(PStockNewsPresenter.self) { (_, stock: CompanyStock, stockStatus: StockStatus?, news: [CompanyNews]?) in
			StockNewsPresenter(stock: stock, stockStatus: stockStatus, news: news);
		}
		
		container.register(PAddStockPresenter.self) { r in AddStockPresenter(interactor: r.resolve(PMainBusiness.self)!) }
	}
	
	// MARK: - Views
	private func registerViews() {
		// AppManager
		container.register(PAppManager.self) { r in
			AppManager(interactor: r.resolve(PMainBusiness.self)!,
					   logger: r.resolve(Logging.self)!,
					   di: self)
		}.inObjectScope(.container);
		
		// Supportive Views
		container.register(PAlert.self) { r in Alert(logger: r.resolve(Logging.self)!) }
		
		container.register(LanguageSwitcher.self) { (r, completion: @escaping VoidClosure) in
			let instance = LanguageSwitcher();
			instance.config(completed: completion);
			
			return instance;
		}
		
		container.register(SpinnerView.self) { _ in SpinnerView() }
		
		// View Controllers
		container.register(StocksListVC.self) { r in
			StocksListVC(presenter: r.resolve(PStocksListPresenter.self)!,
						 router: r.resolve(PMainRouter.self)!,
						 di: self)
		}

		container.register(StockDetailsVC.self) { (r, item: CompanyStock) in
			StockDetailsVC(presenter: r.resolve(PStockDetailsPresenter.self, argument: item)!,
						   router: r.resolve(PMainRouter.self)!,
						   di: self)
		}

		container.register(StockNewsVC.self) { (r, stock: CompanyStock, stockStatus: StockStatus?, news: [CompanyNews]?) in
			StockNewsVC(presenter: r.resolve(PStockNewsPresenter.self, arguments: stock, stockStatus, news)!,
						router: r.resolve(PMainRouter.self)!,
						di: self)
		}

		container.register(WebBrowserVC.self) { (_, urlString: String) in
			WebBrowserVC(urlString: urlString)
		}

		container.register(AddStockVC.self) { (r, delegate: AddStockDelegate?) in
			AddStockVC(presenter: r.resolve(PAddStockPresenter.self)!,
					   di: self,
					   delegate: delegate)
		}
	}
	
	// MARK: - View Makers - Root
	func makeRootViewController() -> UIViewController {
		let vc = container.resolve(StocksListVC.self)!;
		vc.title = Localizables.home.text;
		let vcNav = UINavigationController(rootViewController: vc);
		return vcNav;
	}
	
	// MARK: - View Makers - Views
	func makeLanguageSwitcher(completion: @escaping VoidClosure) -> UIViewController {
		return container.resolve(LanguageSwitcher.self, argument: completion)!;
	}
	
	func makeSpinnerView(indicatorColor: UIColor?, backgroundColor: UIColor?) -> UIView {
		let vc = container.resolve(SpinnerView.self)!;
		vc.config(indicatorColor: indicatorColor, backgroundColor: backgroundColor);
		return vc;
	}
	
	// MARK: - View Makers - VCs
	func makeStocksListVC() -> UIViewController {
		return container.resolve(StocksListVC.self)!;
	}
	
	func makeStockDetailsVC(with item: CompanyStock) -> UIViewController {
		return container.resolve(StockDetailsVC.self, argument: item)!;
	}
	
	func makeStockNewsVC(stock: CompanyStock, stockStatus: StockStatus?, news: [CompanyNews]?) -> UIViewController {
		return container.resolve(StockNewsVC.self, arguments: stock, stockStatus, news)!;
	}
	
	func makeWebBrowserVC(urlString: String) -> UIViewController {
		return container.resolve(WebBrowserVC.self, argument: urlString)!;
	}

	func makeAddStockVC(delegate: AddStockDelegate?) -> UIViewController {
		let vc = container.resolve(AddStockVC.self, argument: delegate)!;
		return vc;
	}

	// MARK: - View Makers - Cells
	func makeStockItemCell(from tableView: UITableView, for indexPath: IndexPath, with item: CompanyStock) -> BaseTableViewCell {
		let presenter = container.resolve(PStockItemCellPresenter.self, argument: item)!;
		let cell = StockItemCell.dequeue(from: tableView, for: indexPath);
		cell.inject(presenter: presenter);
		cell.config();
		return cell;
	}
	
	func getStockItemCellType() -> InjectableTableViewCell.Type {
		return StockItemCell.self;
	}
	
	func makeNewsItemCell(from tableView: UITableView, for indexPath: IndexPath, with newsTitle: String) -> BaseTableViewCell {
		let cell = NewsItemCell.dequeue(from: tableView, for: indexPath);
		cell.config(newsTitle: newsTitle);
		return cell;
	}
	
	func getNewsItemCellType() -> InjectableTableViewCell.Type {
		return NewsItemCell.self;
	}
	
	func makeExchangeItemCell(from tableView: UITableView, for indexPath: IndexPath, with text: String) -> BaseTableViewCell {
		let cell = ExchangeItemCell.dequeue(from: tableView, for: indexPath);
		cell.setText(text);
		return cell;
	}
	
	func getExchangeItemCellType() -> InjectableTableViewCell.Type {
		return ExchangeItemCell.self;
	}
	
}
