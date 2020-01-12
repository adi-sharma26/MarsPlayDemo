//
//  ViewController.swift
//  MarsPlayDemo
//
//  Created by Aditya on 08/01/20.
//  Copyright © 2020 Aditya. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(UINib(nibName: "MovieListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.COLLECTION_CELL_MOVIE_LIST)
        }
    }
    
    private var dataList: [[String:Any]]!
    private var totalPages: UInt16 = 1
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[String:Any]]()
        
        if Connectivity.isConnectedToInternet() {
            loadMoreItems()
        } else {
            internetAlert()
        }

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    private func internetAlert() {
        let alert = UIAlertController(title: "", message: "Seems that you're not connected to internet, Please connect to the internet.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- API Calling
    func loadMoreItems() {
        APIManager.getMoviesList(with: URL(string: "\(Constants.API_URL_MOVIE_LIST)page=\(currentPage)&apikey=\(Constants.API_KEY)")!, failure: { (error) in
            print(error)
        }) { (data) in
            print(data)
            let results = data["Search"] as? [[String : Any]]
            if results?.count ?? 0 > 0 {
                self.dataList.append(contentsOf: results!)
                self.totalPages = UInt16(data["totalResults"] as! String)!
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

//MARK:- UICollectionView DataSource and Delegate

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.collectionView.frame.size.width-20)/2
        
        let orientation = UIApplication.shared.statusBarOrientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight) {
            return CGSize(width: cellWidth, height: 300)
        } else {
            return CGSize(width: cellWidth, height: 300)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.COLLECTION_CELL_MOVIE_LIST, for: indexPath) as! MovieListCollectionViewCell
        
        cell.configureCell(dataDict: dataList[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if currentPage < totalPages {
                currentPage += 1
                loadMoreItems()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.STORYBOARD_ID_DETAILS_VC) as! DetailsViewController
        vc.detailsData = dataList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

