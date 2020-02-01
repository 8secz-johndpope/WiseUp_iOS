//
//  StoreItemDetailsView.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import Localize_Swift
import ReactiveKit

extension StoreItemDetailsViewController {
    
    func initUI(image: UIImage, title: String, details: String, cost: Int) {
        let scrollView: UIScrollView = {
            let s = UIScrollView()
            return s
        }()
        let thumbnail: UIImageView = {
            let v = UIImageView(image: image)
            v.contentMode = .scaleAspectFit
            return v
        }()
        let titleLabel: UILabel = {
            let l = UILabel()
            l.text = title
            l.textColor = Colors.DynamicTextColor
            l.font = UIFont.systemFont(ofSize: FontSizes.largeNavTitle, weight: .bold)
            l.numberOfLines = 2
            l.adjustsFontSizeToFitWidth = true
            return l
        }()
        let detailsLabel: UILabel = {
            let l = UILabel()
            l.text = details
            l.textColor = Colors.DynamicTextColor
            l.font = UIFont.systemFont(ofSize: FontSizes.secondaryTitle, weight: .bold)
            l.numberOfLines = 0
            return l
        }()
        
        buyButton = {
            let b = UIButton()
            if item.type == "avatar" {
                if !UserShared.shared.avatarsOwned.contains(item.name) {
                    b.setTitle("Buy for ".localized() + cost.description, for: .normal)
                    b.backgroundColor = Colors.DynamicNavigationBarColor
                    b.setTitleColor(Colors.DynamicNavigationTitleColor, for: .normal)
                    _ = b.reactive.tap.observeNext { [weak self] (_) in
                        self?.buyItem()
                    }
                    return b
                }
                
                
                else {
                    b.setTitle("Already Owned".localized(), for: .normal)
                    b.backgroundColor = Colors.DynamicNavigationBarColor
                    b.setTitleColor(Colors.DynamicNavigationTitleColor, for: .normal)
                    _ = b.reactive.tap.observeNext { [weak self] (_) in
                        self?.buyItem()
                    }
                    return b
                }
            } else if (item.type == "stock") {
                b.setTitle("Buy for ".localized() + cost.description + " per share", for: .normal)
                b.backgroundColor = Colors.DynamicNavigationBarColor
                
                b.setTitleColor(Colors.DynamicNavigationTitleColor, for: .normal)
                _ = b.reactive.tap.observeNext { [weak self] (_) in
                    self?.setStockQuantity()
                }
                return b
                
            } else  {
                if !UserShared.shared.itemsOwned.contains(item.name) {
                    b.setTitle("Buy for ".localized() + cost.description, for: .normal)
                    b.backgroundColor = Colors.DynamicNavigationBarColor
                    b.setTitleColor(Colors.DynamicNavigationTitleColor, for: .normal)
                    _ = b.reactive.tap.observeNext { [weak self] (_) in
                        self?.buyItem()
                    }
                    return b
                }
                
                
                else {
                    b.setTitle("Already Owned".localized(), for: .normal)
                    b.backgroundColor = Colors.DynamicNavigationBarColor
                    b.setTitleColor(Colors.DynamicNavigationTitleColor, for: .normal)
                    _ = b.reactive.tap.observeNext { [weak self] (_) in
                        self?.buyItem()
                    }
                    return b
                }
            }
            
            
            
        }()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.bottom.equalToSuperview()
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
        }
        scrollView.addSubview(thumbnail)
        thumbnail.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp.topMargin).offset(20)
            this.leading.equalTo(view.snp.leading).offset(20)
            this.width.equalTo(view.snp.width).dividedBy(4)
            this.height.equalTo(view.snp.width).dividedBy(4)
        }
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (this) in
            this.leading.equalTo(thumbnail.snp.trailing).offset(20)
            this.top.equalTo(thumbnail.snp.top)
            this.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        scrollView.addSubview(detailsLabel)
        detailsLabel.snp.makeConstraints { (this) in
            this.top.equalTo(thumbnail.snp.bottom).offset(20)
            this.leading.equalTo(thumbnail.snp.leading)
            this.trailing.equalTo(titleLabel.snp.trailing)
        }
        scrollView.addSubview(buyButton!)
        buyButton!.snp.makeConstraints { (this) in
            this.top.equalTo(detailsLabel.snp.bottom).offset(20)
            this.leading.equalTo(detailsLabel)
            this.trailing.equalTo(detailsLabel)
            this.bottom.equalToSuperview()
        }
        buyButton!.layer.cornerRadius = 5
    }
    
}
