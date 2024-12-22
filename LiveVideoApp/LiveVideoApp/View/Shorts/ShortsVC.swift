//
//  ShortsVC.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit

class ShortsVC: UIViewController {

    @IBOutlet weak var shortsCV: UICollectionView!
    private var originalContentOffset: CGPoint?
    let shortsVM = ShortsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        fetchVideos()
        registerForKeyboardNotifications()
    }
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func fetchVideos() {
        shortsVM.fetchVideos(for: .videos) { success, error in
            if success {
                self.fetchComments()
            } else {
                print("Error fetching videos: \(error?.localizedDescription ?? "")")
                AlertView.shared.showActionSheet(on: self, isSuccess: false, message: error?.localizedDescription ?? "Error occured")
            }
        }
    }
    private func fetchComments() {
        shortsVM.fetchComments(for: .comments) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.shortsCV.reloadData()
                }
            } else {
                print("Error fetching videos: \(error?.localizedDescription ?? "")")
                AlertView.shared.showActionSheet(on: self, isSuccess: false, message: error?.localizedDescription ?? "Error occured")
            }
        }
    }
    private func setupCollectionView() {
        shortsCV.dataSource = self
        shortsCV.delegate = self
        shortsCV.isPagingEnabled = true
        shortsCV.contentInset = .zero
        shortsCV.contentInsetAdjustmentBehavior = .never
        shortsCV.allowsSelection = false
        shortsCV.translatesAutoresizingMaskIntoConstraints = false
    }
    // Show keyboard with correct offset position
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let activeCell = getActiveCell() else { return }

        originalContentOffset = shortsCV.contentOffset

        let keyboardHeight = keyboardFrame.height
        let cellFrame = shortsCV.convert(activeCell.frame, to: view)
        let visibleHeight = view.bounds.height - keyboardHeight

        if cellFrame.maxY > visibleHeight {
            let offset = CGPoint(x: shortsCV.contentOffset.x, y: shortsCV.contentOffset.y + (cellFrame.maxY - visibleHeight))
            shortsCV.setContentOffset(offset, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let originalOffset = originalContentOffset {
            shortsCV.setContentOffset(originalOffset, animated: true)
            originalContentOffset = nil
        }
    }
    private func getActiveCell() -> UICollectionViewCell? {
        for cell in shortsCV.visibleCells {
            if let shortCell = cell as? ShortCVCell, shortCell.commentTF.isFirstResponder {
                return shortCell
            }
        }
        return nil
    }
}

// MARK: - CollectionView Delegate & Datasource Methods
extension ShortsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shortsVM.videos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shortCell", for: indexPath) as! ShortCVCell
        cell.configureCell(video: shortsVM.videos[indexPath.row], comments: shortsVM.comments)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
