//
//  ChapterViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Firebase

class ChapterViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var chapters: [Chapter]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Chapters"
        
        setBackground()
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ChapterCell.self, forCellWithReuseIdentifier: "cellId")
        
        navigationItem.title = "Chapters"
        
        loadChapters()
    }
    
    func loadChapters() {
        
        // First Get Pre-Cached Chapters (or empty if nothing cached)
        self.chapters = CacheService.shared.getCachedChapters()
        self.collectionView.reloadData()
        
        // Second, asynchronously check for updates to chapters and download them if needed
        CacheService.shared.getChapters { (chaps) in
            self.chapters = chaps
            self.collectionView.reloadData()
        }
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = chapters?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChapterCell
        
        if let chapter = chapters?[indexPath.item] {
            cell.name = chapter.name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
}

class ChapterCell: BaseCell {
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Chapter Name"
        label.textColor = UIColor.black
        return label
    }()
    
    override func setupViews() {
        
        backgroundColor = UIColor.white
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(named: "Quick Fin Logo")
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(68)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":iconImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0(68)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":iconImageView]))
        
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-125-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel]))
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
    }
}
