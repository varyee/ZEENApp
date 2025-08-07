//
//  ViewController.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/7/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var homeVC: HomeViewController!
    var favoritesVC: FavoritesViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for child in children {
            if let nav = child as? UINavigationController {
                if let hvc = nav.viewControllers.first as? HomeViewController {
                    homeVC = hvc
                    print("we got the hvc")
                } else if let fvc = nav.viewControllers.first as? FavoritesViewController {
                    favoritesVC = fvc
                    print("we got the fvc")
                }
            }
             }
             switchViews(segmentedControl)
    }
    
    //Method to switch the views
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            firstView.alpha = 1
            secondView.alpha = 0
        }
        else {
//            print("Hey I got here")
//            var results =  homeVC.movies
//            print("this is the favorites view: \(results)")
            //favoritesVC.favoriteMovies = homeVC.movies.filter { $0.isFavorite }
            //favoritesVC.tableView.reloadData()
            favoritesVC.fetchFavoritesFromCoreData()
            favoritesVC.tableView.reloadData()
            firstView.alpha = 0
            secondView.alpha = 1
        }
    }
    
    
}
