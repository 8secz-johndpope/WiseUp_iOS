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
        (collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        dismiss(animated: true, completion: nil)
    }
}

class AvatarCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageName: String? {
        didSet {
            iconImageView.image = UIImage(named: imageName!)
        }
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setupViews() {
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (this) in
            this.center.equalToSuperview()
            this.width.equalToSuperview()
            this.height.equalToSuperview()
        }
    }
    
}

