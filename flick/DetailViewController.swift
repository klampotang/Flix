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
        let completeString = "http://image.tmdb.org/t/p/w500"+imageURLViaSegue
        let imageUrl = NSURL(string: completeString)
        
        detailImageView.setImageWithURL(imageUrl!)
        
        overviewLabel.text = overviewViaSegue
        titleLabel.text = titleViaSegue
        releaseDateLabel.text = "Release Date: \(releasedateViaSegue) "
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
