//
//  CollectionsViewController.swift
//  flick
//
//  Created by Kelly Lampotang on 6/16/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionsView: UICollectionView!
    
    @IBOutlet weak var backArrow: UINavigationItem!
    var moviesColl:[NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionsView.backgroundColor = UIColorFromHex(0x92AA83, alpha:1)
        
        collectionsView.dataSource = self
        getData()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let moviesColl = moviesColl {
            return moviesColl.count
        } else
        {
            return 0
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionsView.dequeueReusableCellWithReuseIdentifier("movieCollCell", forIndexPath: indexPath) as! MovieCollectionCell
        
        let movie = moviesColl![indexPath.row]
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL+posterPath)
        let rating = movie["vote_average"] as! Int
        cell.collectionCellImage.setImageWithURL(imageURL!)
        cell.ratingLabel.text = "Rating: \(rating)/10"
        cell.backgroundColor = UIColorFromHex(0xB0BEA9, alpha:1)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! DetailViewController
        let indexPath1 = collectionsView.indexPathForCell(sender as! MovieCollectionCell)
        let movie = moviesColl![indexPath1!.row]
        let photoURL = movie.valueForKeyPath("poster_path") as? String
        vc.imageURLViaSegue = photoURL!
        
        vc.overviewViaSegue = (movie.valueForKey("overview") as? String)!
        vc.titleViaSegue = (movie.valueForKey("title") as? String)!
        vc.releasedateViaSegue = (movie.valueForKey("release_date") as? String)!
    }
    
    func getData()
    {
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a49de16b4f06f894f89cc75373d53be0"
        //Need to get your own key for assignment
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            
            //self.collectionsView.reloadData()
            
            
            if dataOrNil != nil {
                let data = dataOrNil
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data!, options:[]) as? NSDictionary {
                    self.moviesColl = responseDictionary["results"] as? [NSDictionary]
                    self.collectionsView.reloadData()
                }
            }
        })
        task.resume()
        
        
    }
}

