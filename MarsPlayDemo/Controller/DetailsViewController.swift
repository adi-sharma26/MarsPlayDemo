//
//  DetailsViewController.swift
//  MarsPlayDemo
//
//  Created by Aditya on 12/01/20.
//  Copyright © 2020 Aditya. All rights reserved.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    
    var detailsData: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    private func setData() {
        let url = URL(string: detailsData["Poster"] as? String ?? "")!
        var kf = posterImage.kf
        kf.indicatorType = .activity
        let placeHolderImage = UIImage(named: "ic_placeholder")
        posterImage.kf.setImage(with: url, placeholder: placeHolderImage, options: [.cacheOriginalImage])
        let calendar = Calendar.current
        let date = Date()
        let currentYear = calendar.component(.year, from: date)
        let releaseYear = Int(String((detailsData["Year"] as? String)?.prefix(4) ?? "0"))
        labelTitle.text = detailsData["Title"] as? String
        labelYear.text = "\(currentYear - releaseYear!) years ago"
        labelType.text = detailsData["Type"] as? String
    }

}
