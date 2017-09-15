//
//  NowPlayingViewController.swift
//  ImdbClient
//
//  Created by Cesar Cavazos on 9/14/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self

        self.moviesTableView.rowHeight = 140
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        
        cell.movieTitleLabel?.text = "Movie \(indexPath.row + 1)"
        cell.overviewLabel?.text = "Overview \(indexPath.row + 1)"
        cell.releaseDateLabel?.text = "Release Date \(Date())"
        
        return cell
    }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moviesTableView.deselectRow(at: indexPath, animated: true)
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
