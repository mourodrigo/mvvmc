//  ViewModel.swift
//  tmdb

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelProtocol: BaseViewModelProtocol {
    func pushCoord()
    func presentCoord()
}

class ViewModel: BaseViewModel, ViewModelProtocol {

    //************************************************
    // MARK: - Properties
    //************************************************

    private let _disposeBag = DisposeBag()

    private weak var _coordinator: CoordinatorProtocol?

    //************************************************
    // MARK: - Lifecycle
    //************************************************

    init(coordinator: CoordinatorProtocol) {
        _coordinator = coordinator
        super.init()
//        self.setIsLoading(true)
    }

    //************************************************
    // MARK: - Handle Actions
    //************************************************

    func pushCoord() {
        _coordinator?.pushCoord()
    }
    
    func presentCoord() {
        _coordinator?.presentCoord()
    }

}
