//
//  ShortCVCell.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit

class ShortCVCell: UICollectionViewCell {
    private let playerView = AVPlayerView()
    
    func configureCell(video: Video, comments: [Comment]) {
        contentView.addSubview(playerView)
        playerView.frame = contentView.frame
        setupPlayer(url: video.video)
    }
    private func setupPlayer(url: String) {
        guard let videoURL = URL(string: url) else { return }
        playerView.configurePlayer(with: videoURL)
    }
}
