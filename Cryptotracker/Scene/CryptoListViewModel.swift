//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 04/11/21.
//

import Foundation

final class CryptoListViewModel {
    private var cryptos = [CryptoCellModel]()
    private let repository: CryptoRepository
    
    enum State {
        case loading
        case error(error: Error)
        case loaded
    }
    
    var currentState: State = .loading {
        didSet {
            stateChanged?()
        }
    }
    
    var stateChanged: (() -> Void)?
    
    var numberOfItems: Int {
        switch currentState {
        case .loaded:
            return cryptos.count
        default:
            return 0
        }
    }
    
    var stateDescription: String? {
        switch currentState {
        case .loaded:
            return numberOfItems == 0 ? "No cryptos founded" : nil
        case .error(let error):
            return error.localizedDescription
        case .loading:
            return "Loading cryptos..."
        }
    }
    
    init(repository: CryptoRepository = CryptoRemoteRepository()) {
        self.repository = repository
    }
    
    func modelForRow(at index: Int) -> CryptoCellModel {
        cryptos[index]
    }
    
    func loadCryptos() {
        currentState = .loading
        repository.requestAllCryptos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cryptos):
                self.cryptos = cryptos.map{ CryptoCellModel(crypto: $0) }
                self.currentState = .loaded
            case .failure(let error):
                print(error)
                self.currentState = .error(error: error)
            }
        }
    }
}
