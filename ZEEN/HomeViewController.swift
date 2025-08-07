//
//  ViewController.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/4/25.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    let searchController = UISearchController()

    //Link the collectionView
    @IBOutlet var collectionView: UICollectionView!
    
    //Create an array of movies with type Movie(movie model) which stores the movie we get from the API
    var movies: [Movie] = []
    //Store the search results
    var searchResults: [Movie] = []
    
    var isShowingFavorites = false
    
    //Know if the user is searching
    var isSearching = false
    
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar()
        navigationItem.searchController = searchController
 
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        // Customization for dark backgrounds
        let searchBar = searchController.searchBar
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white // Text color when typing
            textField.backgroundColor = UIColor(white: 1, alpha: 0.2) // Light transparent background
            textField.tintColor = .white // Cursor color

            // Customize placeholder color
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search for a movie",
                attributes: [.foregroundColor: UIColor.lightGray]
            )

            // Icon (magnifying glass) and clear (x) button color
            textField.leftView?.tintColor = .white
            textField.rightView?.tintColor = .white
        }
        // Minimal style removes the background border
        searchBar.searchBarStyle = .minimal
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        //Register a N
        collectionView.register(MovieCollectionViewCell.nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)

        //Help specify the data
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        getMovies { fetchedMovies in
            DispatchQueue.main.async {
                self.movies = fetchedMovies
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        collectionView.reloadData()
    }
    
    
    func isMovieFavorited(id: Int) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking if movie is favorited: \(error)")
            return false
        }
    }
    
    
    
    
//    func searchBar() {
//        //Add search Bar
//        let searchController = UISearchController(searchResultsController: nil)
//
//        //Has a placeholder in the search text field
//        searchController.searchBar.placeholder = "Search movies"
//
//        //Does not hide the title when typing
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.hidesNavigationBarDuringPresentation = false
//
//        // Access the search bar's text field to customize appearance
//        let searchBar = searchController.searchBar
//        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
//            textField.textColor = .white  // Text color
//            textField.backgroundColor = UIColor(white: 1, alpha: 0.2)  // Light transparent background
//            textField.tintColor = .white  // Cursor color
//
//            // Customize placeholder color
//            textField.attributedPlaceholder = NSAttributedString(
//                string: "Search movies",
//                attributes: [.foregroundColor: UIColor.lightGray]
//            )
//
//            // Icon (magnifying glass) and clear (x) button color
//            textField.leftView?.tintColor = .white
//            textField.rightView?.tintColor = .white
//        }
//
//        // Minimal style removes the background border
//        searchBar.searchBarStyle = .minimal
//
//
//        //Add searchBar to navigationBar
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//    }
    
    
    
////    // HomeViewController.swift
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("i got here first")
//        if segue.identifier == "ShowFavorites" {
//            if let favoritesVC = segue.destination as? FavoritesViewController {
//                print("i got here")
//                favoritesVC.favoriteMovies = movies.filter { $0.isFavorite }
//            }
//        }
//    }
    
}









//Help pick up interaction with the cell
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        //Store the data of the cell selected
        let selectedMovie = isSearching ? searchResults[indexPath.item] : movies[indexPath.item]
        
        // Safely instantiate DetailViewController
            if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                
                // Pass the whole movie object
                detailVC.movie = selectedMovie
                
                navigationController?.pushViewController(detailVC, animated: true)
            } else {
                print("Error: Could not instantiate DetailViewController")
            }
 
        
        //Pass the title to the new view controller
//        newVC?.name = selectedMovie.title
//        newVC?.movieImage = selectedMovie.image
        
//        self.navigationController?.pushViewController(newVC!, animated: true)
    }
}








extension HomeViewController: UICollectionViewDataSource{
    
    //FUNC - Tells the collectionView how many cells to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? searchResults.count : movies.count
    }
    
    //FUNC - Returns a cell that appears on the screen,indexPath tells you which row or item the collection view is asking about.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create a reusable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        var movie = isSearching ? searchResults[indexPath.item] : movies[indexPath.item]
        let isFavorite = isMovieFavorited(id: movie.id)
        movie.isFavorite = isFavorite
        cell.configure(with: movie)
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
}




extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 250)
    }
    
}



extension HomeViewController: MovieCollectionViewCellDelegate {
    
    func movieCell(_ cell: MovieCollectionViewCell, didToggleFavoriteFor indexPath: IndexPath) {
        
        var movie = isSearching ? searchResults[indexPath.item] : movies[indexPath.item]
        movie.isFavorite.toggle()

        if isSearching {
            searchResults[indexPath.item] = movie
            if let realIndex = movies.firstIndex(where: { $0.id == movie.id }) {
                movies[realIndex] = movie
            }
        } else {
            movies[indexPath.item] = movie
        }
        
        // 4. Update Core Data
               let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if movie.isFavorite {
                // Save to Core Data
                let favorite = FavoriteMovie(context: context)
                favorite.id = Int64(movie.id)
                favorite.title = movie.title
                favorite.overview = movie.overview
                favorite.posterPath = movie.posterPath
                favorite.isFavorite = true
            }
        
        else {
                    // Remove from Core Data
                    let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
                    if let results = try? context.fetch(fetchRequest) {
                        for object in results {
                            context.delete(object)
                        }
                    }
                }
        
        do {
                 try context.save()
                 print("Core Data updated!")
             } catch {
                 print("Failed to update Core Data: \(error)")
             }
        
        // 5. Reload the cell
          collectionView.reloadItems(at: [indexPath])
   
     
        
        // Notify parent to update favorites if needed
        if let parentVC = parent as? ViewController, parentVC.segmentedControl.selectedSegmentIndex == 1 {
            parentVC.favoritesVC.favoriteMovies = movies.filter { $0.isFavorite }
            parentVC.favoritesVC.tableView.reloadData()
        }
    }
}


extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let userSearchText = searchController.searchBar.text
        else {
            return
        }
        if userSearchText == "" {
            isSearching = false
            collectionView.reloadData()
        }
        else {
            isSearching = true
            searchMovies(query: userSearchText) {
                [weak self] results
                in
                print("Search returned \(results.count) movies")
                DispatchQueue.main.async {
                    self?.searchResults = results
                    self?.collectionView.reloadData()
                }
            }
            print("Searching for: \(userSearchText)")
            
        }
    }
    
    
}


extension HomeViewController: UISearchBarDelegate {
    
}





