//
//  ChapterViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import GradientLoadingBar
import SnapKit

class ChapterViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let gradientLoadingBar = GradientLoadingBar()
    private let cellId = "cellId"
    private let widthOffset: CGFloat = 20
    var chapters: [Chapter]?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chapters".localized()
        setBackground() // Won't work here because the background is a collection view
        initCollectionView()
        initUI()
        loadChapters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func initCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChapterCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.layer.masksToBounds = false
    }
    
    func initUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (this) in
            this.centerX.equalToSuperview()
            this.top.equalToSuperview()
            this.bottom.equalToSuperview()
            this.width.equalToSuperview().offset(-widthOffset)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = chapters?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChapterCell
        
        if let chapter = chapters?[indexPath.item] {
            cell.name = chapter.name
            cell.imageName = chapter.imageName
            
            if UserShared.shared.achievementsCompleted.contains(chapter.name + "PerfectChapter".localized()) {
                cell.setAcedFlag()
            } else {
                cell.removeFlag()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chapter = chapters?[indexPath.row]
        let gameVC = GameViewController()
        gameVC.questionNumber = 1
        gameVC.questions = chapter?.questions
        gameVC.chapterName = chapter?.name
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - widthOffset, height: 100)
    }
    
}

class ChapterCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        label.text = "-"
        label.textColor = Colors.DynamicTextColor
        return label
    }()
    
    func setupViews() {
        backgroundColor = Colors.DynamicChapterCellBackground
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (this) in
            this.centerY.equalToSuperview()
            this.leading.equalToSuperview().offset(20)
            this.width.equalTo(50)
            this.height.equalTo(50)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (this) in
            this.centerY.equalToSuperview()
            this.leading.equalTo(iconImageView.snp.trailing).offset(20)
        }
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }
    
    func setNewFlag() {
        let triLabelView = TriLabelView(frame: bounds)
        triLabelView.labelText = "NEW".localized()
        triLabelView.position = .TopRight
        triLabelView.textColor = UIColor.white
        triLabelView.viewColor = UIColor.systemOrange
        triLabelView.tag = 7
        addSubview(triLabelView)
    }
    
    func setAcedFlag() {
        let triLabelView = TriLabelView(frame: bounds)
        triLabelView.labelText = "ACED".localized()
        triLabelView.position = .TopRight
        triLabelView.textColor = UIColor.white
        triLabelView.viewColor = Colors.FidelityGreen!
        triLabelView.tag = 7
        addSubview(triLabelView)
    }
    
    func removeFlag() {
        if let viewWithTag = viewWithTag(7) {
            viewWithTag.removeFromSuperview()
        }
    }
}
