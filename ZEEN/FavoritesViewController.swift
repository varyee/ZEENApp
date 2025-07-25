//
//  FavoritesViewController.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/7/25.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController{
    
    let searchController = UISearchController()

    @IBOutlet weak var tableView: UITableView!
    
    // Variable for my favorited movies
    var favoriteMovies: [Movie] = []
    
    //Store the search results
    var searchResults: [Movie] = []
    
    //Know if the user is searching
    var isSearching = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavoritesFromCoreData()
        
        //searchBar()
        navigationItem.searchController = searchController
     
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        
        // --- Customization for dark backgrounds ---
        let searchBar = searchController.searchBar
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white // Text color when typing
            textField.backgroundColor = UIColor(white: 1, alpha: 0.2) // Light transparent background
            textField.tintColor = .white // Cursor color

            // Customize placeholder color
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search for a favorite movie",
                attributes: [.foregroundColor: UIColor.lightGray]
            )

            // Icon (magnifying glass) and clear (x) button color
            textField.leftView?.tintColor = .white
            textField.rightView?.tintColor = .white
        }
        // Minimal style removes the background border
        searchBar.searchBarStyle = .minimal
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
       // searchBar()
        //Renders the data on the tableView
        tableView.dataSource = self
        tableView.delegate = self

      
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
    
    func convertToMovie(favorite: FavoriteMovie) -> Movie {
        return Movie(
            id: Int(favorite.id),
            title: favorite.title ?? "",
            posterPath: favorite.posterPath,
            overview: favorite.overview ?? "",
            isFavorite: favorite.isFavorite
        )
    }
    
    
    func fetchFavoritesFromCoreData() {
        
        //Get the context from the AppDelegate
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Fetch the favorite movies from Core Data/create a fetch request
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        
        //fetch the data from Core Data and convert it to our Movie model
        do {
            let results = try context.fetch(fetchRequest)
            favoriteMovies = results.map { convertToMovie(favorite: $0) }
        }
        catch {
            print("Error fetching favorites: \(error)")
        }
    }

    
}




extension FavoritesViewController: UITableViewDataSource {
    //This tableview should have this number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchResults.count : favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        //Deque a cell and set it as a custom cell created
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
       
        //Get the iboutlet created and set it to the image and label data we have
        //cell.movieIconImage.image = UIImage(named: movie.posterPath ?? "")
        
        //Create an object to store each item in our array of data movies
        let movie = isSearching ? searchResults[indexPath.item] : favoriteMovies[indexPath.row]
        
        //Check if the movie has a poster path
        if let posterPath = movie.posterPath {
            
            //Load the movie path from the internet
            let imageUrlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            
            //Turns that string into a real URL object that Swift can use to request the image
            if let url = URL(string: imageUrlString) {
                
                //starts a background network request to download the image data
                URLSession.shared.dataTask(with: url) {
                    data, _, error
                    in
                    
                    //Checks that the image data came through and no errors occurred
                    if let data = data, error == nil {
                        
                        DispatchQueue.main.async {
                            //It converts the downloaded data into a real image
                            cell.movieIconImage.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        cell.movieTitleLabel.text = movie.title
       
        
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Store the data of the cell selected
        let selectedMovie = favoriteMovies[indexPath.row]
        print(selectedMovie)
        
        //When a cell is tapped on, we want to transfer the cell's data to the next screen
        if let newVC = storyboard?.instantiateViewController(withIdentifier: "FavoriteDetailViewController") as? FavoriteDetailViewController {
            
            newVC.movie = selectedMovie
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
}



extension FavoritesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let userSearchText = searchController.searchBar.text else {
            return
        }
        
        if userSearchText.isEmpty {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            // Filter favoriteMovies locally by title (case-insensitive)
            searchResults = favoriteMovies.filter { movie in
                movie.title.lowercased().contains(userSearchText.lowercased())
            }
            tableView.reloadData()
        }
    }
    
    
}


extension FavoritesViewController: UISearchBarDelegate {
    
}
