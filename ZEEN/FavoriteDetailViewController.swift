//
//  FavoriteDetailViewController.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/30/25.
//

import UIKit

class FavoriteDetailViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var Description: UITextView!
    
    var movie: Movie?
    
    var name = ""
    var movieImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        label.text = movie?.title
        Description.text = movie?.overview
        
        //Check if the movie has a poster path
        if let posterPath = movie?.posterPath {
            
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
                            self.Image.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
        
        

        
       
    }
    
    
    
  


}
