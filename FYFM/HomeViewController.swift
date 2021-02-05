//
//  HomeViewController.swift
//  FYFM
//
//  Created by Сергей on 25.01.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var CollectionViewTopRated: UICollectionView!
    @IBOutlet weak var CollectionViewPopular: UICollectionView!
    @IBOutlet weak var CollectionViewLastest: UICollectionView!
    @IBOutlet weak var CollectionViewNowPlaying: UICollectionView!
    @IBOutlet weak var CollectionViewUpcoming: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    let networkDataFetcher = NetWorkDataFetcher()
    var filmsListResponse: FilmsListResponse? = nil
    
    let homePageUrlString = ["/movie/top_rated","/movie/popular","/movie/latest","/movie/now_playing","/movie/upcoming"]
    
    func searchProcess(searchText:String) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(searchText)&page=1"
        self.networkDataFetcher.fetchTraks(urlString: urlString) { [self] (searchResponse) in
            guard let searchResponse =  searchResponse else { return }
                self.filmsListResponse = searchResponse
                if let count = self.filmsListResponse?.totalResults, count > 0 {
                    if let responce = self.filmsListResponse {
                        var i = 0
                        var imagesUrlArray: [String] = []
                        for film in responce.results {
                            var posterPathUrl = "https://vcunited.club/wp-content/uploads/2020/01/No-image-available-2.jpg"
                            if let optionlaPosterPath = film.posterPath   {
                                posterPathUrl = "https://image.tmdb.org/t/p/w500/" + optionlaPosterPath
                            }
                            imagesUrlArray.append(posterPathUrl)
                            i=i+1
                            if i == (self.filmsListResponse?.results.count)! {
                                var a = 0
                                let imagesArray = self.networkDataFetcher.loadAllImages(images: imagesUrlArray)
                                print(imagesArray)
                                for var film in responce.results {
                                    self.filmsListResponse?.results[a].posterData = imagesArray[a]
                                    print(a, imagesArray[a])
                                    a=a+1
                                    if a == (self.filmsListResponse?.results.count)! {
//                                        self.collectionView.reloadData()
                                        print("ну типа готово")
                                    }
                                }
                            }
                        }
                    }
                } else {
//                    self.alert()
//                    self.collectionView.reloadData()
                    print("жопа какая-то а не запрос")
                }
            }
        }

}
