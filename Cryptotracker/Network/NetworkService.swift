//
//  NetworkService.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 04/11/21.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case noData
    case invalidStatusCode(code: Int)
    case custom(error: Error)
}

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func requestList<Model: Decodable>(url: URL, completion: @escaping (Result<[Model], NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.badRequest))
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, !(200...299 ~= statusCode) {
                return completion(.failure(.invalidStatusCode(code: statusCode)))
            }
            
            do {
                let list = try JSONDecoder().decode([Model].self, from: data)
                return completion(.success(list))
            } catch {
                return completion(.failure(.custom(error: error)))
            }
        }
        
        task.resume()
    }
    
    func requestAllCryptos(completion: @escaping (Result<[Crypto], NetworkError>) -> Void) {
        guard let url = URL(string: Constants.assetsBaseUrl + "?apikey=" + Constants.apiKey) else {
            return completion(.failure(.badRequest))
        }
        
        requestList(url: url) { [weak self] (result: Result<[Crypto], NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(var cryptos):
                self.requestAllIcons { result in
                    switch result {
                    case .success(let icons):
                        for (index, crypto) in cryptos.enumerated() {
                            let icon = icons.first(where: { $0.assetId == crypto.assetId })
                            cryptos[index].image = icon?.url
                        }
                        return completion(.success(cryptos))
                    case .failure(let error):
                        return completion(.failure(error))
                    }
                }
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    func requestAllIcons(completion: @escaping (Result<[Icon], NetworkError>) -> Void) {
        guard let url = URL(string: Constants.assetsIconsUrl + "?apikey=" + Constants.apiKey) else {
            return completion(.failure(.badRequest))
        }
        
        requestList(url: url, completion: completion)
    }
    
//    func requestAllCryptos(completion: @escaping (Result<[Crypto], NetworkError>) -> Void) {
//        guard let url = URL(string: Constants.assetsBaseUrl + "?apiKey=" + Constants.apiKey) else {
//            return completion(.failure(.badRequest))
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                return completion(.failure(.noData))
//            }
//
//            if let response = response as? HTTPURLResponse, !(200...299 ~= response.statusCode) {
//                return completion(.failure(.invalidStatusCode(code: response.statusCode)))
//            }
//            do {
//                var cryptos = try JSONDecoder().decode([Crypto].self, from: data)
//                self.requestAllIcons { result in
//                    switch result {
//                    case .success(let icons):
//                        for (index, crypto) in cryptos.enumerated() {
//                            let icon = icons.first(where: { $0.assetId == crypto.assetId})
//                            cryptos[index].image = icon?.url
//                            print(icon?.url ?? "image not found")
//                        }
//                        return completion(.success(cryptos))
//                    case .failure(let error):
//                        return completion(.failure(.custom(error: error)))
//                    }
//                }
//            } catch {
//                return completion(.failure(.custom(error: error)))
//            }
//        }
//        task.resume()
//    }
//
//    func requestAllIcons(completion: @escaping (Result<[Icon], NetworkError>) -> Void) {
//        guard let url = URL(string: Constants.assetsIconsUrl + "?apikey=" + Constants.apiKey) else {
//            return completion(.failure(.badRequest))
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                return completion(.failure(.noData))
//            }
//
//            do {
//                let icons = try JSONDecoder().decode([Icon].self, from: data)
//                return completion(.success(icons))
//            } catch {
//                return completion(.failure(.custom(error: error)))
//            }
//        }
//        task.resume()
//    }
}
