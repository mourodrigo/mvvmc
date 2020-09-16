//  AppDelegate.swift
//  tmdb

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    //************************************************
    // MARK: - Variables
    //************************************************

    static let shared: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return delegate
    }()

    var window: UIWindow?

}

extension AppDelegate: UIApplicationDelegate {

    //************************************************
    // MARK: - Lifecycle
    //************************************************

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }

}

extension AppDelegate {

    func setup() {


        //storing some repositories
        SharedLocator.shared.register(ConfigurationRepositoryProtocol.self,
                                      instance: ConfigurationRepository())

        SharedLocator.shared.register(ImageRepository.self, instance: AFImageRepository())


        // setup root window (Startup Module)
        let rootCoordinator = Coordinator()
        let rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.backgroundColor = .white
        rootWindow.rootViewController = UINavigationController.init(rootViewController: rootCoordinator.viewController)
        rootWindow.makeKeyAndVisible()
        window = rootWindow

        let appCoordinator = AppCoordinator(rootCoordinator: rootCoordinator)
        SharedLocator.shared.register(AppCoordinatorProtocol.self, instance: appCoordinator)



    }
}

