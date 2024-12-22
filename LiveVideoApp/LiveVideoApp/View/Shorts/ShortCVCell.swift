//
//  ShortCVCell.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit

class ShortCVCell: UICollectionViewCell {
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var commentsViewWidth: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    private let playerView = AVPlayerView()
    var comments : [Comment] = []
    
    func configureCell(video: Video, comments: [Comment]) {
        containerView.frame = contentView.frame
        playerView.frame = contentView.frame
        containerView.addSubview(playerView)
        setupPlayer(url: video.video)
        // Bottom view width adjust to device size
        commentsViewWidth.constant = UIScreen.main.bounds.size.width - 40
        self.comments = comments
        setupCommentsTable()
    }
    func setupCommentsTable() {
        commentsTable.delegate = self
        commentsTable.dataSource = self
    }
    private func setupPlayer(url: String) {
        guard let videoURL = URL(string: url) else { return }
        playerView.configurePlayer(with: videoURL)
    }
}

extension ShortCVCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTVCell
        commentCell.configureComments(comment: comments[indexPath.row])
        return commentCell
    }
}
