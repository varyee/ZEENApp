//
//  DetailViewController.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/30/25.
//

import UIKit


class DetailViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // This holds the selected movie
    var movie: Movie?
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedMovie = movie {
            label.text = selectedMovie.title
            descriptionTextView.text = selectedMovie.overview
            
            if let imagePath = selectedMovie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)") {
                Image.load(url: url)
            }
        }
    }

}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


