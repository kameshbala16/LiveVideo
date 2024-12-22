//
//  ShortsVC.swift
//  LiveVideoApp
//
//  Created by Kamesh Bala on 21/12/24.
//

import UIKit

class ShortsVC: UIViewController {

    @IBOutlet weak var shortsCV: UICollectionView!
    let shortsVM = ShortsVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        fetchVideos()
    }
    private func fetchVideos() {
        shortsVM.fetchVideos(for: .videos) { success, error in
            if success {
                // fetch comments
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
        shortsCV.translatesAutoresizingMaskIntoConstraints = false
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
