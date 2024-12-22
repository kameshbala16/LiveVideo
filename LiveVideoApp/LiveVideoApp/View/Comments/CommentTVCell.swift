//
//  CommentTVCell.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 22/12/24.
//

import UIKit

class CommentTVCell: UITableViewCell {

    @IBOutlet weak var commentsTV: UITextView!
    @IBOutlet weak var profileImage: ImageViewDesign!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureComments(comment: Comment) {
        // Each comment should display the username, profilePictureURL, and comment.
        if let url = URL(string: comment.picURL) {
            profileImage.sd_setImage(with: url)
        } else {  
            profileImage.image = UIImage(named: "user")
            profileImage.backgroundColor = .appGrey.withAlphaComponent(0.4)
        }
        commentsTV.attributedText = returnHomeDetailTV(comment: comment)
    }
    func returnHomeDetailTV(comment: Comment) -> NSMutableAttributedString {
        let homeAttribute = NSMutableAttributedString()
        let nameAttribute = NSAttributedString(string: "\(comment.username)\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7), NSAttributedString.Key.font: AppFont().setFont(size: 12)])
        let commentAttribute = NSAttributedString(string: comment.comment, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont().setFont(size: 12)])
        
        homeAttribute.append(nameAttribute)
        homeAttribute.append(commentAttribute)
        return homeAttribute
    }
    

}
