//
//  MoviesViewController.swift
//  flick
//
//  Created by Kelly Lampotang on 6/15/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var movies:[NSDictionary]?
    var textValue = "title"
    var endpoint: String!
    
    override func viewDidLoad() {
        self.networkErrorLabel.hidden = true
        //
        self.tableView.allowsMultipleSelection = true;
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        getData(1, refreshControl: nil)
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let overview = movie["overview"] as! String
        cell.titleLabel.hidden = true
        cell.overviewLabel.text = overview
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL+posterPath)
        
        cell.posterView.setImageWithURL(imageURL!)
        cell.setSelected(false, animated: false)

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        if(indexPath.row%2 == 0)
        {
            cell.backgroundColor = UIColorFromHex(0xF1F7EE, alpha: 1)
            
        } else {
            cell.backgroundColor = UIColorFromHex(0xE0EDC5, alpha:1)
        }
        //create a CABasicAnimation that fades from 0 to 1 opacity over 3 seconds
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0.0
        fadeAnimation.toValue = 1.0
        fadeAnimation.duration = 3.0
        // create a CAKeyframeAnimation with a keyPath of "transform"
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform")
        
        // set the CAKeyframeAnimation to go from 10% to 100% scale
        scaleAnimation.values = [NSValue(CATransform3D: CATransform3DMakeScale(0.1, 0.1, 1)), NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1))]
        // specify and "Ease Out" timing function
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        // set the duration of the animation for 3 seconds
        scaleAnimation.duration = 3
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        //let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = ""
        
            
        // add both animations to the Label
        cell.titleLabel.layer.addAnimation(scaleAnimation, forKey: "transform")
        cell.titleLabel.layer.addAnimation(fadeAnimation, forKey: "opacity")
        

        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL+posterPath)
        cell.posterView.alpha = 0.0
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            cell.posterView.alpha = 1.0
            }, completion: nil)
        cell.posterView.setImageWithURL(imageURL!)
        return cell
    }
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    
    func getData(type: Int, refreshControl: UIRefreshControl?) {
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a49de16b4f06f894f89cc75373d53be0"
        //Need to get your own key for assignment
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
            
            self.tableView.reloadData()
            
            if(type == 1)
            {
                // Tell the refreshControl to stop spinning
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            else if(type == 0)
            {
                refreshControl!.endRefreshing()
            }
            if dataOrNil != nil {
                let data = dataOrNil
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data!, options:[]) as? NSDictionary {
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            else //If there's no data
            {
                self.networkErrorLabel.hidden = false
            }
        })
        task.resume()
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    func refreshControlAction(refreshControl:UIRefreshControl)
    {
        getData(0, refreshControl: refreshControl)
    }
    
}
