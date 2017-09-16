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
    
    let lowResPosterHostname = "https://image.tmdb.org/t/p/w45";
    let highResPosterHostname = "https://image.tmdb.org/t/p/original";
    
    var posterEndpoint: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let contentWidth = contentScrollView.bounds.width
        let contentHeight = contentScrollView.bounds.height * 3
        contentScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        // Do any additional setup after loading the view.
        
        // Load the low resolution image as soon as possible
        if let imageEndpoint = posterEndpoint {
            if let imageUrl = URL(string: lowResPosterHostname + imageEndpoint) {
                posterBackground.setImageWith(imageUrl)
                loadHighResImage()
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
                posterBackground.setImageWith(imageUrl)
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
