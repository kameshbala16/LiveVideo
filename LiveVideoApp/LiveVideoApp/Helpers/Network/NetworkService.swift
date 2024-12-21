//
//  NetworkService.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import Foundation

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func fetchData(from fileName: String, completion: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - Network Service Implementation
class NetworkService: NetworkServiceProtocol {
    func fetchData(from fileName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            completion(.failure(NSError(domain: "File not found", code: -1, userInfo: nil)))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
}
