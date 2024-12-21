//
//  Comment.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import Foundation

// MARK: - Comment
struct Comment: Codable {
    let id: Int
    let username: String
    let picURL: String
    let comment: String
}
