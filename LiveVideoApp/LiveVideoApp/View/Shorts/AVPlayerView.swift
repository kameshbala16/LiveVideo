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
    private var playerItemDidReachEndObserver: Any?
    var isPlaying = false
    
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
        stop()
        player = AVPlayer(url: url)
        playerLayer?.player = player
        // Video should automatically play and loop.
        playerItemDidReachEndObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.loopPlayer()
        }
        play()
    }
    private func loopPlayer() {
        player?.seek(to: .zero)
        play()
    }
    func play() {
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func stop() {
        pause()
        player?.seek(to: .zero)
        playerLayer?.player = nil
        player = nil
        if let observer = playerItemDidReachEndObserver {
            NotificationCenter.default.removeObserver(observer)
            playerItemDidReachEndObserver = nil
        }
    }
    deinit {
        stop()
    }
}
