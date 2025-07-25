//
//  Movie.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/16/25.
//

import Foundation
import UIKit


//Blueprint of what we want the response to be from the API and it defines a movie type and that can be used to decode json and encode it
struct Movie: Codable {
    //Movie properties
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    var isFavorite: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        //The key in the json should match my swift property
        case posterPath = "poster_path"
        case overview
    }
}





struct MovieResponse: Codable {
    //Returns an array of movies or the entire json response we get from the API
    let results: [Movie]
}



//Function to load the movies from TDMI API into my app
//Completion - requests for the data and when done prompts, eg:go get the movies, and when you're done, tell me by calling this completion function with the results
func getMovies(completion: @escaping ([Movie]) -> Void) {
    let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=db6daf59acc638496209cfd7aed14ad0&language=en-US&page=1"
    
    //Convert the url string into a URL object
    guard let url = URL(string: url) else {
        print("Invalid URL")
        completion([])
        return
    }
    
    
    //Network request to go and fetch data
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error
        in
        
        //Check if there is no data and there is a network error, print error
        guard let data = data, error == nil else {
            print("No data or error: \(error?.localizedDescription ?? "Unknown error")")
            completion([])
            return
        }
        
        //Now that we have data, Create a variable for the decoded response
        do {
            //converting the bytes(from: data) received into codable data(MovieResponse)
            let Movieresult = try JSONDecoder().decode(MovieResponse.self, from: data)
            completion(Movieresult.results)
        }
        
        catch {
            print("Failed to convert \(error.localizedDescription)")
            completion([])
        }
        
    }
    //Start the network call
    task.resume()
}


//A function that takes the search query and fetches movies from the api
func searchMovies(query: String, completion: @escaping ([Movie]) -> Void) {
    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let apiKey = "db6daf59acc638496209cfd7aed14ad0"
    let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(encodedQuery)&page=1"
    
    //Convert the url string into a URL object
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion([])
        return
    }
    
    //Fetch the data from the API
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error
        in
        
        //Check if there is no data and there is a network error, print error
        guard let data = data, error == nil else {
            print("No data or error: \(error?.localizedDescription ?? "Unknown error")")
            completion([])
            return
        }
        
        //Now that we have data, Create a variable for the decoded response
        do {
            //converting the bytes(from: data) received into codable data(MovieResponse)
            let Movieresult = try JSONDecoder().decode(MovieResponse.self, from: data)
            completion(Movieresult.results)
        }
        
        catch {
            print("Failed to convert \(error.localizedDescription)")
            completion([])
        }
    }
    //Start the network call
    task.resume()
}







//struct MovieResponse: Codable {
//    let results: [Movie]
//}
//
//
//struct Movie: Codable {
//    let id: Int
//    let title: String
//    let overview: String
//    let posterPath: String?
//    var isFavorite: Bool
//    
//    enum CodingKeys: String, CodingKey {
//        case id, title, overview
//        case posterPath = "poster_path"
//    }
//}
//
//
//func fetchMovies(completion: @escaping ([Movie]) -> Void) {
//    let apiKey = "db6daf59acc638496209cfd7aed14ad0"
//    let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=db6daf59acc638496209cfd7aed14ad0&language=en-US&page=1"
//    
//    guard let url = URL(string: urlString) else {
//        print("Invalid URL")
//        return
//    }
//
//    URLSession.shared.dataTask(with: url) { data, response, error in
//        if let data = data {
//            do {
//                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
//                DispatchQueue.main.async {
//                    completion(decodedResponse.results)
//                }
//            } catch {
//                print("Decoding error: \(error)")
//            }
//        } else if let error = error {
//            print("HTTP error: \(error)")
//        }
//    }.resume()
//}



//var movies: [Movie] = [
//    Movie(title: "Daddy Day Care", image: UIImage(named: "TestImage")!, isFavorite: false),
//    Movie(title: "Little Mermaid", image: UIImage(named: "Disney")!, isFavorite: true),
//]
