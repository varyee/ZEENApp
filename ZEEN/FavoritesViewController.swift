//
//  FavoritesViewController.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/7/25.
//

import UIKit

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func searchBar() {
        //Add search Bar
        let searchController = UISearchController(searchResultsController: nil)
        
        //Has a placeholder in the search text field
        searchController.searchBar.placeholder = "Search movies"
        
        //Does not hide the title when typing
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Access the search bar's text field to customize appearance
            let searchBar = searchController.searchBar
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.textColor = .white  // Text color
                textField.backgroundColor = UIColor(white: 1, alpha: 0.2)  // Light transparent background
                textField.tintColor = .white  // Cursor color

                // Customize placeholder color
                textField.attributedPlaceholder = NSAttributedString(
                    string: "Search movies",
                    attributes: [.foregroundColor: UIColor.lightGray]
                )

                // Icon (magnifying glass) and clear (x) button color
                textField.leftView?.tintColor = .white
                textField.rightView?.tintColor = .white
            }

            // Minimal style removes the background border
            searchBar.searchBarStyle = .minimal

        
        //Add searchBar to navigationBar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Go To Home" {
            
        }
    }

}
