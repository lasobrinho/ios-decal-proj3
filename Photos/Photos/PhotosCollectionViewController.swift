//
//  TestViewViewController.swift
//  Photos
//
//  Created by Lucas Alves Sobrinho on 4/9/16.
//  Copyright © 2016 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var photos: [Photo]!
    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var searchField: UITextField!
    let api = InstagramAPI()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionViewLayout()
        installNavBarSearchField()
        configureRefreshController()
        api.loadPhotos("", completion: didLoadPhotos)
    }
    
    func configureRefreshController() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refreshCollectionView), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView!.addSubview(refreshControl)
    }
    
    func refreshCollectionView() {
        api.loadPhotos("", completion: didLoadPhotos)
    }
    
    func configureCollectionViewLayout() {
        getScreenSizeInfo()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        self.collectionView?.contentInset.top = -20
    }
    
    func getScreenSizeInfo() {
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
    }
    
    func installNavBarSearchField() {
        searchField = UITextField(frame: CGRectMake(0, 0, 250, 25))
        searchField.placeholder = "Search"
        searchField.font = UIFont.systemFontOfSize(15)
        searchField.borderStyle = UITextBorderStyle.RoundedRect
        searchField.autocorrectionType = UITextAutocorrectionType.No
        searchField.keyboardType = UIKeyboardType.Default
        searchField.returnKeyType = UIReturnKeyType.Done
        searchField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        searchField.textAlignment = .Center
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: UIControlEvents .AllEditingEvents)
        self.navigationItem.titleView = searchField
    }
    
    func textFieldDidChange(textField: UITextField) {
        api.loadPhotos(textField.text!, completion: didLoadPhotos)
    }
    
    func loadImageForCell(cell: PhotosCollectionViewCell, image: UIImage) {
        cell.image.image = image
        cell.addSubview(cell.image)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotosCollectionViewCell", forIndexPath: indexPath) as! PhotosCollectionViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: PhotosCollectionViewCell, indexPath: NSIndexPath) {
        if photos != nil {
            let api = InstagramAPI()
            let photo = photoForIndexPath(indexPath)
            api.loadThumbnail(photo, cell: cell, completion: loadImageForCell)
        }
        
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        cell.image = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth / 3, height: screenWidth / 3))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC: DetailViewController = DetailViewController()
        detailVC.photo = photoForIndexPath(indexPath)
        api.loadLargeImage(detailVC.photo, detailVC: detailVC, completion: pushDetailViewController)
    }
    
    func pushDetailViewController(detailVC: DetailViewController, image: UIImage) {
        detailVC.image = UIImageView(frame: CGRect(x: 0, y: (screenHeight)/2 - (screenWidth/2) + 32, width: screenWidth, height: screenWidth))
        detailVC.backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: screenHeight, height: screenHeight))
        detailVC.image.image = image
        detailVC.backgroundImage.image = image
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func photoForIndexPath(indexPath: NSIndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    /* Completion handler for API call. DO NOT CHANGE */
    func didLoadPhotos(photos: [Photo]) {
        self.photos = photos
        self.collectionView!.reloadData()
        self.refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
