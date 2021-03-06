//  MoviesListViewModel.swift
//  tmdb

import Foundation
import RxSwift
import RxCocoa

enum MoviesListCollectionViewModelStatus {
    case ready
    case loading
    case error(error: Error)
}

protocol MoviesListCollectionViewModelProtocol: BaseViewModelProtocol {
    var genreText: Observable<String> { get }
    var status: Observable<MoviesListCollectionViewModelStatus> { get }
    func item(for row: Int) -> Movie
    var numberOfItems: Int { get }
    func didSelectItem(at index: Int)
}

class MoviesListCollectionViewModel: BaseViewModel, MoviesListCollectionViewModelProtocol {

    //************************************************
    // MARK: - Properties
    //************************************************

    private let _disposeBag = DisposeBag()

    private weak var _coordinator: MoviesListCollectionCoordinatorProtocol?

    private let _discoverRepository: DiscoverMoviesRepository

    private let _genreText = BehaviorSubject<String>(value: "")
    var genreText: Observable<String> { _genreText.asObserver() }

    private let _status = BehaviorSubject<MoviesListCollectionViewModelStatus>(value: .loading)
    var status: Observable<MoviesListCollectionViewModelStatus> { _status.asObserver() }

    private var _movies = [Movie]()
    private let _genre: Genre

    private var canLoadMore = true
    private var _onMovieSelection: MovieSelectionClosure

    //************************************************
    // MARK: - Lifecycle
    //************************************************

    init(coordinator: MoviesListCollectionCoordinatorProtocol, genre: Genre, onMovieSelection: @escaping MovieSelectionClosure, discoverRepository: DiscoverMoviesRepository) {
        _discoverRepository = discoverRepository
        _coordinator = coordinator
        _genre = genre
        _onMovieSelection = onMovieSelection
        super.init()
        bind()
    }

    private func bind() {
        _discoverRepository.state.bind { [weak self] (status) in
            switch status {
            case .updated(genre: let genre, movies: let movies):
                self?._movies = movies
                self?._genreText.onNext(genre.name)

                //preventing looping from collectionview reloadData()
                //which will call the same repository again

                switch try? self?._status.value() {
                case .ready: break
                default:
                    self?._status.onNext(.ready)
                }

                self?.canLoadMore = true
            case .idle:
                self?._status.onNext(.ready)
            case .loading:
                if self?._movies.count == 0 { self?._status.onNext(.loading) }
                self?.canLoadMore = false
            case .error(error: let error):
                self?._status.onNext(.error(error: error))
            }
        }.disposed(by: _disposeBag)

        fetch(genre: _genre)

    }

    private func fetch(genre: Genre, index: Int = 30) {
        self._discoverRepository.fetch(genre: genre, resultIndex: index)
    }

    func item(for row: Int) -> Movie {
        let preLoadingOffset = 10
        if canLoadMore {
            self._discoverRepository.fetch(genre: self._genre, resultIndex: row+preLoadingOffset)
        }
        return _movies[row]
    }

    func didSelectItem(at index: Int) {
        _onMovieSelection(_movies[index], _genre)
    }

    var numberOfItems: Int {
        return _movies.count
    }
}
