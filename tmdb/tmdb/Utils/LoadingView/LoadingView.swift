//
//  NibView.swift
//  tmdb

import Foundation
import UIKit
import Cartography

class LoadingView: NibView {

	//************************************************
	// MARK: - @IBOutlets
	//************************************************

	@IBOutlet private weak var loadingAnimationContainer: UIView!

	//************************************************
	// MARK: - Properties
	//************************************************

	// Singleton
	private static var _instance: LoadingView?
    @IBOutlet weak var activity: UIActivityIndicatorView!

	//************************************************
	// MARK: - Life Cycle
	//************************************************

	override func viewDidLoad() {
		super.viewDidLoad()
        if #available(iOS 13.0, *) {
            activity.style = .large
        } else {
            activity.style = .whiteLarge
        }
	}

	static func show(on parent: UIView) {
		guard _instance == nil else { return }

		let loadingView = LoadingView()
		parent.addSubview(loadingView)
		Cartography.constrain(loadingView, parent) { (view, container) in view.edges == container.edges }
		_instance = loadingView
	}

	static func hide() {
		guard let instance = _instance else { return }

		instance.removeFromSuperview()

		_instance = nil
	}
}
