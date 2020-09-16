//  AppDelegate.swift
//  tmdb
//  Based on -> https://github.com/quickbirdstudios/DependencyInjectionPlayground/blob/master/DI.playground/Contents.swift

import Foundation
import UIKit

//************************************************
// MARK: Resolver
//************************************************

protocol SharedResolver {}

//************************************************
// MARK: Factory
//************************************************

private protocol SharedFactory {
    associatedtype SharedType

    func resolve(_ resolver: SharedResolver) -> SharedType
}

private extension SharedFactory {
    func supports<T>(_ type: T.Type) -> Bool {
        return type == SharedType.self
    }
}

private struct BasicSharedFactory<SharedType>: SharedFactory {
    private let factory: (SharedResolver) -> SharedType

    init(_ type: SharedType.Type, factory: @escaping (SharedResolver) -> SharedType) {
        self.factory = factory
    }

    func resolve(_ resolver: SharedResolver) -> SharedType {
        return factory(resolver)
    }
}

private final class AnySharedFactory {
    private let _resolve: (SharedResolver) -> Any
    private let _supports: (Any.Type) -> Bool

    init<T: SharedFactory>(_ sharedFactory: T) {
        _resolve = { resolver -> Any in sharedFactory.resolve(resolver) }
        _supports = { $0 == T.SharedType.self }
    }

    func resolve<SharedType>(_ resolver: SharedResolver) -> SharedType {
		guard let result = _resolve(resolver) as? SharedType else { fatalError() }
        return result
    }

    func supports<SharedType>(_ type: SharedType.Type) -> Bool {
        return _supports(type)
    }
}

//************************************************
// MARK: Locator
//************************************************

class SharedLocator: SharedResolver {

    // Singleton
    static let shared = SharedLocator()

    private var factories: [AnySharedFactory]

    // to avoid init it ouside
    private init() {
        self.factories = []
    }

    // Register
    func release() {
        factories.removeAll()
    }

    @discardableResult
    func register<T>(_ interface: T.Type, instance: T) -> SharedLocator {
        return register(interface) { _ in instance }
    }

    @discardableResult
    func register<SharedType>(_ type: SharedType.Type, _ factory: @escaping (SharedResolver) -> SharedType) -> SharedLocator {
        guard !factories.contains(where: { $0.supports(type) }) else {
            fatalError("There is another instance registered for '\(String(describing: type))'.")
        }

        let newFactory = BasicSharedFactory<SharedType>(type, factory: { resolver in
            factory(resolver)
        })

        factories.append(AnySharedFactory(newFactory))
        return self
    }

    // Resolver
    private func resolve<SharedType>(_ type: SharedType.Type) -> SharedType {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
            fatalError("No suitable factory found for '\(String(describing: type))'.")
        }
        return factory.resolve(self)
    }
}

// Wrapper to specific Instances (Services/Providers)
extension SharedLocator {

	// App Coordinator
	var appCoordinator: AppCoordinatorProtocol { return self.resolve(AppCoordinatorProtocol.self) }

    // ConfigurationRepository
    var configurationRepository: ConfigurationRepositoryProtocol { return self.resolve(ConfigurationRepositoryProtocol.self) }



}
