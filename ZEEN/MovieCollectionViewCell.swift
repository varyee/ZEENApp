//
//  MovieCollectionViewCell.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/14/25.
//

import UIKit

protocol MovieCollectionViewCellDelegate: AnyObject {
    func movieCell(_ cell: MovieCollectionViewCell, didToggleFavoriteFor indexPath: IndexPath)
}


class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    var selectedMovie: Movie?
    

    weak var delegate: MovieCollectionViewCellDelegate?
    
    var indexPath: IndexPath?

    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        // Make sure the movie exists
        guard let indexPath = indexPath
        else {
            return
        }
        
        delegate?.movieCell(self, didToggleFavoriteFor: indexPath)
        
//        print("Favorite status for  previous'\(movie.title)' is now \(movie.isFavorite)")
//        // Toggle the isFavorite property
//        movie.isFavorite = !movie.isFavorite
        
//        print("Favorite status for second update '\(movie.title)' is now \(movie.isFavorite)")
        
        // Update the heart icon
//        let heartImageName = movie.isFavorite ? "heart.fill" : "heart"
//        sender.setImage(UIImage(systemName: heartImageName), for: .normal)
//        
//        print("Favorite status for '\(movie.title)' is now \(movie.isFavorite)")
        
        // Notify the delegate (ViewController) about the change
        //delegate?.movieCell(self, didToggleFavoriteFor: indexPath)
        
    }
    
    
    static var nib: UINib {
           return UINib(nibName: "MovieCollectionViewCell", bundle: nil)
       }
    
    
    static let identifier = "MovieCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    //Takes the movie object as a parameter and uses it to update the UI inside the cell
    func configure (with movie: Movie) {
        
        //Saves the passed in Movie in the function
        selectedMovie = movie
        
        //sets the cell’s title label to display the movie’s title
        titleLabel.text = movie.title
        
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
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
        //If the movie doesn't have a posterPath, then no image is set
        else {
            imageView.image = nil // or a placeholder
        }
        
        //decide which heart icon to show
        let heartImageName = movie.isFavorite ? "heart.fill" : "heart"
        
        //Sets that heart icon as the image on the favorite button
        favoriteButton.setImage(UIImage(systemName: heartImageName), for: .normal)
    }
    
    
    
    //Register the cell
    func nib() -> UINib {
        return UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    }
    
    
    

}
