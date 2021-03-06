//
//  ViewController.swift
//  FYFM
//
//  Created by Сергей on 07.12.2020.
//
import UIKit

class ViewController: UIViewController,UIAlertViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lastestButton: UIButton!
    @IBOutlet weak var nowPlayingButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var topRatedButton: UIButton!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    let apiKey = "e7d6c37e59198290cfb7b07ee39bec9f"
    let networkDataFetcher = NetWorkDataFetcher()
    var filmsListResponse: FilmsListResponse? = nil
    var someIndex = Int()
    
    let alertController = UIAlertController(title: "Alert", message: "This is an alert.", preferredStyle: .alert)
            

    
    private var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchProcess(searchText:String) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(searchText)&page=1"
        
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(_) in
        self.networkDataFetcher.fetchTraks(urlString: urlString) { [self] (searchResponse) in
            guard let searchResponse =  searchResponse else { return }
                self.filmsListResponse = searchResponse
                if let count = self.filmsListResponse?.totalResults, count > 0 {
                    if let responce = self.filmsListResponse {
                        var i = 0
                        for  film in responce.results {
                            self.filmsListResponse?.results[i].posterData = self.networkDataFetcher.imageLoad(posterPath: film.posterPath)
                            i=i+1
                            if i == (self.filmsListResponse?.results.count)! {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                } else { self.present(alertController, animated: true, completion: nil) }
            }
//        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.reloadData()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmsListResponse?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 50) / 3 //some width
            let height = (width * 1.5)+40 //ratio
            print ("frame.size.width = \(self.view.frame.size.width) cell width = \(width)")
            return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let film = filmsListResponse?.results[indexPath.row]
        
        cell.myLable.textColor = UIColor.black
        cell.backgroundColor = UIColor.darkGray // make cell more visible in our example project
        cell.layer.borderColor = UIColor.black.cgColor
        
        cell.myImage.image = UIImage(data: (film?.posterData)!)
        cell.myLable.text = film?.title
        return cell
    }
    
    // change background color when user touches cell and set someIndex
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.red
        someIndex = indexPath.item
    }
    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
      
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.blue
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showFilmSegue" else { return }
        guard let destination = segue.destination as? FillmViewController else { return }
        
        let film = filmsListResponse?.results[someIndex]
        
        destination.imageData = (film?.posterData)!
        destination.filmTitle = film?.title ?? "no title"
        destination.overview = film?.overview ?? "no overview"
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
        if let text = self.searchBar.text {
            searchProcess(searchText: text)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchProcess(searchText: searchText)
    }
}
