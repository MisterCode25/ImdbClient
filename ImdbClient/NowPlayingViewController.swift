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
    
    var movies: [NSDictionary] = [];
    let posterHostname = "https://image.tmdb.org/t/p/w342";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self

        self.moviesTableView.rowHeight = 162
        
        // Do any additional setup after loading the view.
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.movieTitleLabel?.text = movie["title"] as? String
        cell.overviewLabel?.text = movie["overview"] as? String
        let releaseDate = movie["release_date"] as! String
        cell.releaseDateLabel?.text = "Release Date \(releaseDate)"
        
        if let imageEndpoint = movie["poster_path"] as? String {
            if let imageUrl = URL(string: posterHostname + imageEndpoint) {
                cell.posterImageView.setImageWith(imageUrl)
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
