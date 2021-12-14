//
//  CryptoViewModelTests.swift
//  CryptoTrackerTests
//
//  Created by Thiago Nepomuceno Silva on 30/11/21.
//

import XCTest
import Moya
@testable import Cryptotracker

class CryptoViewModelTests: XCTestCase {
    func test_loadCrypto_asynchronous() {
        //Given
        let expect = expectation(description: "loadCrypto")
        let sut = CryptoListViewModel()
        
        //When
        
        sut.stateChanged = {
            switch sut.currentState {
            case .loaded:
                expect.fulfill()
            default: break
            }
        }
        sut.loadCryptos()
        
        //Then
        wait(for: [expect], timeout: 20)
        XCTAssertEqual(sut.numberOfItems, 13863)
    }
    
    func test_loadCrypto_success_Mock() {
        //Arrange
        let mockRepository = MockCryptoRepository()
        let sut = CryptoListViewModel(repository: mockRepository)
        mockRepository.resultAllCryptos = .success([])
        mockRepository.resultAllIcons = .failure(CryptoError.MockError)
        //Act
        sut.loadCryptos()
        
        //Assert
        XCTAssertEqual(sut.numberOfItems, 0)
    }
    
    func test_loadCrypto_error_mock() {
        let mockRepository = MockCryptoRepository()
        let sut = CryptoListViewModel(repository: mockRepository)
        mockRepository.resultAllCryptos = .failure(CryptoError.MockError)
        
        sut.stateChanged = {
            if case .error(let error) = sut.currentState {
                let cryptoError = error as? CryptoError
                XCTAssertEqual(cryptoError, CryptoError.MockError)
            }
        }
        sut.loadCryptos()
    }
    
    func test_loadCrypto_moya() {
        let provider = MoyaProvider<CryptoTarget>(stubClosure: MoyaProvider.immediatelyStub)
        let repository = CryptoRemoteRepository(provider: provider)
        let sut = CryptoListViewModel(repository: repository)
        
        sut.loadCryptos()
        
        XCTAssertEqual(sut.numberOfItems, 1)
    }
    
    enum CryptoError: Error {
        case MockError
    }
    
}

class MockCryptoRepository: CryptoRepository {
    var resultAllCryptos: (Result<[Crypto], Error>)? = nil
    var resultAllIcons: (Result<[Icon], Error>)? = nil
    var countDidCallRequestAllCryptos = 0
    
    func requestAllCryptos(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        countDidCallRequestAllCryptos += 1
        guard let resultAllCryptos = resultAllCryptos else {
            return
        }
        completion(resultAllCryptos)
    }
    
    func requestAllIcons(completion: @escaping (Result<[Icon], Error>) -> Void) {
        guard let resultAllIcons = resultAllIcons else {
            return
        }
        completion(resultAllIcons)
    }
    
    
}
