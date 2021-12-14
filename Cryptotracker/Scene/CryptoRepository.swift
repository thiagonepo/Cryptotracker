//
//  CryptoRepository.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 16/11/21.
//

import Foundation
import Moya

protocol CryptoRepository: AnyObject {
    func requestAllCryptos(completion: @escaping (Result<[Crypto], Error>) -> Void)
    func requestAllIcons(completion: @escaping (Result<[Icon], Error>) -> Void)
}

final class CryptoRemoteRepository: CryptoRepository {
    let provider: MoyaProvider<CryptoTarget>
    
//    init(provider: MoyaProvider<CryptoTarget> = MoyaProvider<CryptoTarget>(plugins: CryptoTarget.availablePlugins)) {
    init(provider: MoyaProvider<CryptoTarget> = MoyaProvider<CryptoTarget>()) {
//    init(provider: MoyaProvider<CryptoTarget> = MoyaProvider<CryptoTarget>(stubClosure: MoyaProvider.delayedStub(2))) {
        self.provider = provider
    }
    
    func requestAllCryptos(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        provider.request(.loadCryptos) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moyaResponse):
                do {
                    var cryptos = try moyaResponse.map([Crypto].self)
                    self.requestAllIcons { result in
                        switch result {
                        case .failure(let error):
                            return completion(.failure(error))
                        case .success(let icons):
                            for (index, crypto) in cryptos.enumerated() {
                                let icon = icons.first(where: { $0.assetId == crypto.assetId })
                                cryptos[index].image = icon?.url
                            }
                            return completion(.success(cryptos))
                        }
                    }
                } catch {
                    return completion(.failure(error))
                }
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    func requestAllIcons(completion: @escaping (Result<[Icon], Error>) -> Void) {
        provider.request(.loadImages) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let icons = try moyaResponse.map([Icon].self)
                    return completion(.success(icons))
                } catch {
                    return completion(.failure(error))
                }
            case let .failure(error):
                return completion(.failure(error))
            }
        }
    }
}
