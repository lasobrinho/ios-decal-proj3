//
//  DetailViewController.swift
//  Photos
//
//  Created by Lucas Alves Sobrinho on 4/9/16.
//  Copyright © 2016 iOS DeCal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var image: UIImageView!
    var backgroundImage: UIImageView!
    var heartButton: UIButton!
    var posterNameLabel: UILabel!
    var postDateLabel: UILabel!
    var likesLabel: UILabel!
    var photo: Photo!
    var upperStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(backgroundImage)
        addBlurEffect()
        configureUpperStackView()
        self.view.addSubview(image)
        installLabels()
        installHeartButton()
        addConstraints()
    }
    
    func addConstraints() {
        image.translatesAutoresizingMaskIntoConstraints = false
        upperStackView.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        let imageCenterX = NSLayoutConstraint(item: image, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        let imageCenterY = NSLayoutConstraint(item: image, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
        let imageWidth = NSLayoutConstraint(item: image, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        let imageHeight = NSLayoutConstraint(item: image, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        
        let upperStackViewTop = upperStackView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor)
        let upperStackViewBottom = NSLayoutConstraint(item: upperStackView, attribute: .Bottom, relatedBy: .Equal, toItem: image, attribute: .Top, multiplier: 1, constant: 0)
        let upperStackViewLeft = NSLayoutConstraint(item: upperStackView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .LeftMargin, multiplier: 1, constant: 0)
        let upperStackViewRigth = NSLayoutConstraint(item: upperStackView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .RightMargin, multiplier: 1, constant: 0)
        
        let likesLabelTop = NSLayoutConstraint(item: likesLabel, attribute: .Top, relatedBy: .Equal, toItem: image, attribute: .Bottom, multiplier: 1, constant: 10)
        let likesLabelLeft = NSLayoutConstraint(item: likesLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .LeftMargin, multiplier: 1, constant: 0)
        
        let heartButtonTop = NSLayoutConstraint(item: heartButton, attribute: .Top, relatedBy: .Equal, toItem: image, attribute: .Bottom, multiplier: 1, constant: 10)
        let heartButtonRight = NSLayoutConstraint(item: heartButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .RightMargin, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activateConstraints([imageCenterX, imageCenterY, imageWidth, imageHeight, upperStackViewTop, upperStackViewBottom, upperStackViewLeft, upperStackViewRigth, likesLabelTop, likesLabelLeft, heartButtonTop, heartButtonRight])
    }
    
    func configureUpperStackView() {
        upperStackView = UIStackView()
        upperStackView.axis = .Horizontal
        upperStackView.alignment = .Fill
        upperStackView.spacing = 0
        upperStackView.distribution = .EqualSpacing
        self.view.addSubview(upperStackView)
    }
    
    func installHeartButton() {
        heartButton = UIButton()
        if(photo.liked) {
            heartButton.setBackgroundImage(UIImage(named: "heart-icon-liked.png"), forState: .Normal)
        } else {
            heartButton.setBackgroundImage(UIImage(named: "heart-icon-notliked.png"), forState: .Normal)
        }
        heartButton.addTarget(self, action: #selector(like), forControlEvents: .TouchUpInside)
        view.addSubview(heartButton)
    }
    
    func like() {
        if(photo.liked) {
            heartButton.setBackgroundImage(UIImage(named: "heart-icon-notliked.png"), forState: .Normal)
            photo.liked = false
            photo.likes! -= 1
        } else {
            heartButton.setBackgroundImage(UIImage(named: "heart-icon-liked.png"), forState: .Normal)
            photo.liked = true
            photo.likes! += 1            
        }
        likesLabel.text = String(photo.likes) + " likes"
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func installLabels() {
        posterNameLabel = UILabel()
        posterNameLabel.text = photo.username
        posterNameLabel.sizeToFit()
        posterNameLabel.textColor = UIColor.lightGrayColor()
        upperStackView.addArrangedSubview(posterNameLabel)
        
        postDateLabel = UILabel()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        let dateString = dateFormatter.stringFromDate(photo.createdTime)
        postDateLabel.text = dateString
        postDateLabel.sizeToFit()
        postDateLabel.textColor = UIColor.lightGrayColor()
        upperStackView.addArrangedSubview(postDateLabel)
        
        likesLabel = UILabel()
        likesLabel.text = String(photo.likes) + " likes"
        likesLabel.sizeToFit()
        likesLabel.textColor = UIColor.lightGrayColor()
        view.addSubview(likesLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
