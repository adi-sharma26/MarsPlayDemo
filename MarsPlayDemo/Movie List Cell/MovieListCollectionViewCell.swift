//
//  MovieListCollectionViewCell.swift
//  MarsPlayDemo
//
//  Created by Aditya on 09/01/20.
//  Copyright © 2020 Aditya. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 10.0
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        mainView.layer.shadowRadius = 8
        mainView.layer.shadowOpacity = 0.5
        posterImageView.layer.cornerRadius = 10.0
    }
    
    func configureCell(dataDict: [String:Any]) {
        let calendar = Calendar.current
        let date = Date()
        let currentYear = calendar.component(.year, from: date)
        let releaseYear = Int(String((dataDict["Year"] as? String)?.prefix(4) ?? "0"))
        let url = URL(string: dataDict["Poster"] as? String ?? "")!
        var kf = posterImageView.kf
        kf.indicatorType = .activity
        let placeHolderImage = UIImage(named: "ic_placeholder")
        posterImageView.kf.setImage(with: url, placeholder: placeHolderImage, options: [.cacheOriginalImage])
        labelTitle.text = dataDict["Title"] as? String
        labelYear.text = "\(currentYear - releaseYear!) years ago"
        labelType.text = dataDict["Type"] as? String
    }
}
