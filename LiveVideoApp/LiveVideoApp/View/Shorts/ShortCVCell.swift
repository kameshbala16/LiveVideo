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
    
    let playerView = AVPlayerView()
    var comments : [Comment] = []
    var allComments : [Comment] = []
    private var timer: Timer?
    var commentIndex = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureGestureRecognizer()
        commentTF.returnKeyType = .send
        commentTF.delegate = self
    }
    func configureGestureRecognizer() {
        // Single Tap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTap.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(singleTap)
        
        // Double Tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
        
        // Ensure single-tap waits for double-tap to fail
        singleTap.require(toFail: doubleTap)
        
        // Post Comments Tap
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(postComment))
        postView.addGestureRecognizer(commentTap)
        
        // Gift Tap
        let giftTap = UITapGestureRecognizer(target: self, action: #selector(postGift))
        giftView.addGestureRecognizer(giftTap)
        
        // Rose Tap
        let roseTap = UITapGestureRecognizer(target: self, action: #selector(postRose))
        roseView.addGestureRecognizer(roseTap)
    }
    @objc private func handleSingleTap() {
        print("Play or Pause Video")
        if playerView.isPlaying {
            playerView.pause()
        } else {
            playerView.play()
        }
        AlertView.shared.showAlert(isPlaying: playerView.isPlaying, on: contentView)
    }
    
    @objc private func handleDoubleTap() {
        print("Animate Hearts")
        animateHearts(on: self.containerView)
    }
    @objc func postComment() {
        print("Post Comment")
        guard let comment = commentTF.text, !comment.isEmpty else { return }
        addComment(comment: comment)
        commentTF.text = ""
        commentTF.resignFirstResponder()
    }
    @objc func postRose() {
        print("Post Rose")
    }
    @objc func postGift() {
        print("Post Gift")
    }
    func addComment(comment: String) {
        // After a comment is added, put it into the comments scroll and scroll the other comments up with animation.
        let ID = Int.random(in: 1000...9999)
        let username = "Kamesh Bala"
        let picURL = "https://media.licdn.com/dms/image/v2/D5603AQF8UL1R7k8vAw/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1675819091439?e=1740614400&v=beta&t=IRMS-U7QAuqAgCSb2WKq0n_Mrj63x9nCFFUdWXDY4KA"
        let commentObject = Comment(id: ID, username: username, picURL: picURL, comment: comment)
        allComments.insert(commentObject, at: comments.count)
        startAddingComments()
        DispatchQueue.main.async {
            self.commentsTable.reloadData()
        }
    }
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
        // Adding comments every 2 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
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
// MARK: - TextField Delegate Methods
extension ShortCVCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let comment = textField.text, !comment.isEmpty else {
            return false
        }
        
        addComment(comment: comment)
        
        textField.text = ""
        
        textField.resignFirstResponder()
        
        return true
    }
}
// MARK: - Tableview Delegate & Datasource Methods
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
// MARK: - Add Gradient View to TableView
extension UITableView {
    // MARK: - BONUS: The topmost comment should have a gradient mask that makes the text appear to fade to transparent.
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
