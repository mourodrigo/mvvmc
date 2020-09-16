//  ViewController.swift
//  tmdb

import UIKit
import RxSwift
import RxCocoa

class ViewController: BaseViewController {
    //************************************************
    // MARK: - @IBOutlets
    //************************************************

    //************************************************
    // MARK: - Private Properties
    //************************************************

    private weak var _viewModel: ViewModelProtocol!
    override var viewModel: BaseViewModelProtocol { return _viewModel }
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var present: UIButton!
    private let _disposeBag = DisposeBag()

    //************************************************
    // MARK: - Lifecycle
    //************************************************

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: ViewModelProtocol) {
        _viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupOnLoad()
    }

    //************************************************
    // MARK: - Setup
    //************************************************

    private func setupOnLoad() {
        self.navigationItem.title = "\(String(describing: self))"
    }

    @IBAction func didTapButton(_ sender: Any) {
        _viewModel.pushCoord()
    }

    @IBAction func presentDidTap(_ sender: Any) {
        _viewModel.presentCoord()
    }

}
