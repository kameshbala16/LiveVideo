//
//  Video.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import Foundation

// MARK: - Video
struct Video: Codable {
    let id, userID: Int
    let username: String
    let profilePicURL: String
    let description, topic: String
    let viewers, likes: Int
    let video: String
    let thumbnail: String
}
