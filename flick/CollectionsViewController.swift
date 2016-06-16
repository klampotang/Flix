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
    
    var moviesColl:[NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionsView.dataSource = self
        getData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.collectionCellImage.setImageWithURL(imageURL!)
        
        return cell
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

