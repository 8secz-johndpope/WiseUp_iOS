//
//  ChangeAvatarViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 11/24/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class ChangeAvatarViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    weak var delegate: ProfileViewDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setBackground()
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(AvatarCell.self, forCellWithReuseIdentifier: "cellId")
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //initUI()
        fetchData()
    }
    
    func initUI() {
        title = "Avatars".localized()
    }
    
    func fetchData() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserShared.shared.avatarsOwned.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AvatarCell
        
        let avatarName = UserShared.shared.avatarsOwned[indexPath.item]
        cell.imageName = avatarName
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let avatarName = UserShared.shared.avatarsOwned[indexPath.item]
        UserShared.shared.avatar = avatarName
        FirebaseService.shared.pushUserToFirebase()
        delegate?.updateProfileImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width / 3, height: 100)
        
    }
    
    
}

class AvatarCell: BaseCell {
    
    var imageName: String? {
        didSet {
            iconImageView.image = UIImage(named: imageName!)
        }
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        
        backgroundColor = UIColor.white
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(68)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":iconImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0(68)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":iconImageView]))
        
    }
    
}

