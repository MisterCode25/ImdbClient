//
//  NowPlayingViewController.swift
//  ImdbClient
//
//  Created by Cesar Cavazos on 9/14/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    var movies: [NSDictionary] = [];
    let posterHostname = "https://image.tmdb.org/t/p/w342";
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self

        self.moviesTableView.rowHeight = 162
        
        refreshControl.attributedTitle = NSAttributedString(string: "Updating movie list...")
        refreshControl.addTarget(self, action: #selector(refreshFeed(_:)), for: UIControlEvents.valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        // Do any additional setup after loading the view.
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Pull Down to refresh
    
    func refreshFeed(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    // MARK: - Network Request
    
    func fetchMovies() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: .default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task: URLSessionDataTask = session.dataTask(
        with: request as URLRequest) { (data, response, error) in
            if (error != nil) {
                // There is an error, let's handle it properly
                self.networkErrorView.isHidden = false
            }
            self.networkErrorView.isHidden = true
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print("responseDictionary: \(responseDictionary)")
                    
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    // reload the table view
                    self.moviesTableView.reloadData()
                }
            }
            // Test purposes, we don't really want the user to be waiting but for demostration purposes we want to
            // see the Progress HUD
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.refreshControl.endRefreshing()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
        
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        
        // Customize the selection color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = backgroundView
        
        cell.movieTitleLabel?.text = movie["title"] as? String
        cell.overviewLabel?.text = movie["overview"] as? String
        let releaseDate = movie["release_date"] as! String
        cell.releaseDateLabel?.text = "Release Date \(releaseDate)"
        
        if let imageEndpoint = movie["poster_path"] as? String {
            if let imageUrl = URL(string: posterHostname + imageEndpoint) {
                let imageRequest = URLRequest(url: imageUrl)
                cell.posterImageView.setImageWith(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) in
                        if imageResponse != nil {
                            cell.posterImageView.alpha = 0.0
                            cell.posterImageView.image = image
                            UIView.animate(withDuration: 0.3, animations: {
                                cell.posterImageView.alpha = 1.0
                            })
                        } else {
                            cell.posterImageView.image = image
                        }
                },
                    failure: { (imageRequest, imageResponse, error) in
                        print("There was an error loading the image")
                })
                
            } else {
                print("Url not formed")
            }
        } else {
            print("Image not found")
        }
        
        return cell
    }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moviesTableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Remove the Back text from the navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! MovieDetailViewController
        let indexPath = moviesTableView.indexPath(for: sender as! UITableViewCell)!
        
        let movie = movies[indexPath.row]
        vc.movieDetails = movie
        if let imageEndpoint = movie["poster_path"] as? String {
            vc.posterEndpoint = imageEndpoint
        } else {
            print("Image not found")
        }
    }

}
