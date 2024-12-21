//
//  AVPlayerView.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit
import AVKit

class AVPlayerView: UIView {
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerLayer()
    }

    private func setupPlayerLayer() {
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    func configurePlayer(with url: URL) {
        player = AVPlayer(url: url)
        playerLayer?.player = player
        play()
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player?.pause()
        player?.seek(to: .zero)
    }
}
