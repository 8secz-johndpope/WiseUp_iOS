//
//  ChapterViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Firebase
import GradientLoadingBar

class ChapterViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let gradientLoadingBar = GradientLoadingBar()
    
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
        
        gradientLoadingBar.fadeIn()
        // First Get Pre-Cached Chapters (or empty if nothing cached)
        self.chapters = CacheService.shared.getCachedChapters()
        self.collectionView.reloadData()
        
        // Second, asynchronously check for updates to chapters and download them if needed
        CacheService.shared.getChapters { [unowned self] (chaps) in
            self.chapters = chaps
            self.collectionView.reloadData()
            self.gradientLoadingBar.fadeOut()
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
            cell.imageName = chapter.imageName
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chapter = chapters?[indexPath.row]
        let gameVC = GameViewController()
        gameVC.questionNumber = 1
        gameVC.questions = chapter?.questions
        gameVC.countCorrect = 0
        gameVC.countIncorrect = 0
        navigationController?.pushViewController(gameVC, animated: true)
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
