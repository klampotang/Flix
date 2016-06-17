//
//  DetailViewController.swift
//  flick
//
//  Created by Kelly Lampotang on 6/16/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    
    var imageURLViaSegue = ""
    var titleViaSegue = ""
    var releasedateViaSegue = ""
    var overviewViaSegue = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform")
        
        //create a CABasicAnimation that fades from 0 to 1 opacity over 3 seconds
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0.0
        fadeAnimation.toValue = 1.0
        fadeAnimation.duration = 3.0
        
        
        // set the CAKeyframeAnimation to go from 10% to 100% scale
        scaleAnimation.values = [NSValue(CATransform3D: CATransform3DMakeScale(0.1, 0.1, 1)), NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1))]
        
        let completeString = "http://image.tmdb.org/t/p/w500"+imageURLViaSegue
        let imageUrl = NSURL(string: completeString)
        
        detailImageView.setImageWithURL(imageUrl!)
        
        overviewLabel.text = overviewViaSegue
        titleLabel.text = titleViaSegue
        releaseDateLabel.text = "Release Date: \(releasedateViaSegue) "
        
        // specify and "Ease Out" timing function
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        // set the duration of the animation for 3 seconds
        scaleAnimation.duration = 3
        
        // add both animations to the Label
        titleLabel.layer.addAnimation(scaleAnimation, forKey: "transform")
        titleLabel.layer.addAnimation(fadeAnimation, forKey: "opacity")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyTickets(sender: AnyObject) {
        if let url = NSURL(string: "http://www.fandango.com") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    


}
