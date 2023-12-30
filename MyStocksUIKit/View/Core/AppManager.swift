//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import UIKit

protocol PAppManager {
	func initApp();
	func switchLanguage(via view: UIViewController?);
}

class AppManager: PAppManager {

	// MARK: - Dependencies
	private var interactor: PMainBusiness;
	private var logger: Logging;
	private var di: PDependencyInjector;

	// MARK: - Init
	init(interactor: PMainBusiness, logger: Logging, di: PDependencyInjector) {
		// Dependencies
		self.interactor = interactor;
		self.logger = logger;
		self.di = di;
	}
	
	// MARK: - Functions
	func initApp() {
		interactor.seedInitStocks { [weak self] (result: PMainBusiness.GeneralResult) in
			guard let self = self else { return }
			self.setupAppWindow();
		}
	}
	
	/// Setup app window.
	private func setupAppWindow() {
		// Styles
		setupWindowStyles();
		
		// Setup main view controller (It can be: UIViewController, UINavigationController, or UITabBarController)
		let rootViewController = di.makeRootViewController();

		// Setup app window
		AppDelegate.shared.window?.rootViewController = rootViewController;
		AppDelegate.shared.window?.resignKey();
		AppDelegate.shared.window?.makeKeyAndVisible();
	}
	
	/// Set up global window styles.
	private func setupWindowStyles() {
		// NavBar
		let navAppearance = UINavigationBarAppearance();
		navAppearance.configureWithDefaultBackground();
		navAppearance.backgroundColor = AppColor.viewBackgroundSecondary;
		navAppearance.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: AppColor.textPrimary,
			NSAttributedString.Key.font: AppFont(size: 25, weight: .semibold).font
		];
		
		let buttonAppearance = UIBarButtonItemAppearance(style: .plain);
		buttonAppearance.normal.titleTextAttributes = [.foregroundColor: AppColor.tintPrimary];
		navAppearance.buttonAppearance = buttonAppearance;
		
		UINavigationBar.appearance().tintColor = AppColor.tintPrimary;
		UINavigationBar.appearance().standardAppearance = navAppearance;
		UINavigationBar.appearance().compactAppearance = navAppearance;
		UINavigationBar.appearance().scrollEdgeAppearance = navAppearance;

		// TabBar
		let tabAppearance = UITabBarAppearance();
		tabAppearance.configureWithDefaultBackground();
		tabAppearance.backgroundColor = AppColor.viewBackgroundPrimary;
		UITabBar.appearance().standardAppearance = tabAppearance;
		UITabBar.appearance().tintColor = AppColor.tintPrimary;
	}
	
	/// Shows a view with languages to choose from.
	/// - Parameter view: The view or VC that calls this mehod, to present the switcher.
	func switchLanguage(via view: UIViewController?) {
	}
}
