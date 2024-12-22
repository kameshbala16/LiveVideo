//
//  ShortCVCell.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit

class ShortCVCell: UICollectionViewCell {
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var roseView: UIView!
    @IBOutlet weak var commentTF: TextFieldDesign!
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var commentsViewWidth: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    private let playerView = AVPlayerView()
    var comments : [Comment] = []
    var allComments : [Comment] = []
    private var timer: Timer?
    
    func configureCell(video: Video, comments: [Comment]) {
        timer?.invalidate()
        containerView.frame = contentView.frame
        containerView.backgroundColor = .black
        playerView.frame = contentView.frame
        containerView.addSubview(playerView)
        setupPlayer(url: video.video)
        // Bottom view width adjust to device size
        commentsViewWidth.constant = UIScreen.main.bounds.size.width - 40
        setupCommentsTable()
        self.allComments = comments
        self.comments = Array(comments.prefix(4))
        startAddingComments()
        DispatchQueue.main.async {
            self.commentsTable.reloadData()
        }
    }
    func setupCommentsTable() {
        commentsTable.delegate = self
        commentsTable.dataSource = self
        commentsTable.addTopGradientMask()
    }
    private func setupPlayer(url: String) {
        guard let videoURL = URL(string: url) else { return }
        playerView.stop()
        playerView.configurePlayer(with: videoURL)
    }
    private func startAddingComments() {
        timer?.invalidate()
        var commentIndex = 4
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if commentIndex < self.allComments.count {
                self.comments.append(self.allComments[commentIndex])
                let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
                self.commentsTable.insertRows(at: [indexPath], with: .fade)
                self.commentsTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
                commentIndex += 1
            } else {
                self.timer?.invalidate()
            }
            DispatchQueue.main.async {
                self.commentsTable.reloadData()
            }
        }
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        commentsTable.updateGradientMaskFrame()
    }
}
extension UITableView {
    func addTopGradientMask(topFadeHeight: CGFloat = 60, topColor: UIColor = .clear, middleColor: UIColor = .white) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            topColor.cgColor,
            middleColor.cgColor,
            middleColor.cgColor
        ]
        gradientLayer.locations = [0.0, NSNumber(floatLiteral: topFadeHeight / bounds.height), 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = bounds
        
        let maskLayer = CALayer()
        maskLayer.frame = bounds
        maskLayer.addSublayer(gradientLayer)
        self.layer.mask = maskLayer
    }
    func updateGradientMaskFrame() {
        guard let maskLayer = self.layer.mask, let gradientLayer = maskLayer.sublayers?.first as? CAGradientLayer else { return }
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: gradientLayer.bounds.height)
        maskLayer.frame = bounds
    }
}
