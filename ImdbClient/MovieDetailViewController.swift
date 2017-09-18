//
//  MovieDetailViewController.swift
//  ImdbClient
//
//  Created by Cesar Cavazos on 9/14/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterBackground: UIImageView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var viewDetailsContainer: UIView!
    
    // Local
    let lowResPosterHostname = "https://image.tmdb.org/t/p/w45";
    let highResPosterHostname = "https://image.tmdb.org/t/p/original";
    
    // Pass from parent controller
    var movieDetails: NSDictionary?
    var posterEndpoint: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if movieDetails != nil {
            self.title = movieDetails?["title"] as? String
            titleLabel?.text = movieDetails?["original_title"] as? String
            releaseDateLabel?.text = movieDetails?["release_date"] as? String
            overviewLabel?.text = movieDetails?["overview"] as? String
            
            // TODO: Where to get this value from?
            ratingLabel?.text = "78%"//movieDetails?["release_date"] as? String
            durationLabel?.text = "1 hour 52 minutes"//movieDetails?["release_date"] as? String
            
            overviewLabel.sizeToFit()
            viewDetailsContainer.sizeToFit()
            
            let contentWidth = contentScrollView.bounds.width
            let contentHeight = viewDetailsContainer.frame.origin.y + viewDetailsContainer.bounds.height + 10
            contentScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        }
        
        // Load the low resolution image as soon as possible
        if let imageEndpoint = posterEndpoint {
            if let imageUrl = URL(string: lowResPosterHostname + imageEndpoint) {
                let imageRequest = URLRequest(url: imageUrl)
                posterBackground.setImageWith(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) in
                        if imageResponse != nil {
                            self.posterBackground.alpha = 0.0
                            self.posterBackground.image = image
                            UIView.animate(
                                withDuration: 0.3,
                                animations: {
                                self.posterBackground.alpha = 1.0
                            }, completion: { (result) in
                                // After the low res is loaded, let's load the high res
                                // Adding 1 sec delay for testing purposes
                                let when = DispatchTime.now() + 0.3
                                DispatchQueue.main.asyncAfter(deadline: when) {
                                    self.loadHighResImage()
                                }
                            })
                        } else {
                            self.posterBackground.image = image
                        }
                },
                    failure: { (imageRequest, imageResponse, error) in
                        print("There was an error loading the low res image")
                        self.loadHighResImage()
                })
            } else {
                print("Url not formed")
            }
        } else {
            print("Image not found")
        }
    }
    
    func loadHighResImage() {
        if let imageEndpoint = posterEndpoint {
            if let imageUrl = URL(string: highResPosterHostname + imageEndpoint) {
                let imageRequest = URLRequest(url: imageUrl)
                posterBackground.setImageWith(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) in
                        // We don't care if the image comes from the network or the local cache
                        self.posterBackground.image = image
                }, failure: { (imageRquest, imageResponse, error) in
                    print("There was an error loading the high res image")
                })
            } else {
                print("Url not formed")
            }
        } else {
            print("Image not found")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
