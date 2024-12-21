//
//  ShortsVM.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import Foundation

class ShortsVM {
    private let networkService: NetworkServiceProtocol
    var videos: [Video] = []
    var comments: [Comment] = []
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchVideos(for fileName: Filename, completion: @escaping (Bool, Error?) -> Void) {
        networkService.fetchData(from: fileName.rawValue) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode([String: [Video]].self, from: data)
                    videos = json["videos"] ?? []
                    completion(true, nil)
                } catch {
                    print("Failed to decode json: \(error.localizedDescription)")
                    completion(false, error)
                }
            case .failure(let error):
                print("Failed to fetch data: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }
    
    func fetchComments(for fileName: Filename, completion: @escaping (Bool, Error?) -> Void) {
        networkService.fetchData(from: fileName.rawValue) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode([String: [Comment]].self, from: data)
                    comments = json["comments"] ?? []
                    completion(true, nil)
                } catch {
                    print("Failed to decode json: \(error.localizedDescription)")
                    completion(false, error)
                }
            case .failure(let error):
                print("Failed to fetch data: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }
    
}
