//  Coordinator.swift
//  tmdb

import UIKit

protocol CoordinatorProtocol: BaseCoordinatorProtocol {
    func pushCoord()
    func presentCoord()
}

class Coordinator: BaseCoordinator, CoordinatorProtocol {

    //************************************************
    // MARK: - Properties
    //************************************************

    private var _viewModel: ViewModel!
    private var _viewController: ViewController!
    override var viewController: UIViewController { return _viewController }

//    override var navigationController: UINavigationController? {
//        return _navigationController
//    }

    //************************************************
    // MARK: - Lifecycle
    //************************************************

    override init() {
        super.init()

        _viewModel = ViewModel(coordinator: self)
        _viewController = ViewController(viewModel: _viewModel)
    }

    func pushCoord() {
        let coord = Coordinator.init()
        self.push(coord)
    }

    func presentCoord() {
        let coord = Coordinator.init()
        self.present(coord)
    }

}
