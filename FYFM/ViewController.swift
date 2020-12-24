//
//  ViewController.swift
//  FYFM
//
//  Created by Сергей on 07.12.2020.
//
import UIKit

class ViewController: UIViewController {
    
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
    
    private var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchProcess(searchText:String) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(searchText)&page=1"
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(_) in
            
            self.networkDataFetcher.fetchTraks(urlString: urlString) { (searchResponse) in
            guard let searchResponse =  searchResponse else { return }
            self.filmsListResponse = searchResponse
            self.collectionView.reloadData()
            }
        })
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
        
        
        // убрать это отсюда
        var posterPathUrl = "https://vcunited.club/wp-content/uploads/2020/01/No-image-available-2.jpg"
        if let posterPathSting = film?.posterPath {
            posterPathUrl = "https://image.tmdb.org/t/p/w500/" + posterPathSting
        }
        
        
        let data = try? Data(contentsOf: URL(string: posterPathUrl)! )
        
        if let imageData = data {
            cell.myImage.image = UIImage(data: imageData)
        }
        
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
        var posterPathUrl = "https://vcunited.club/wp-content/uploads/2020/01/No-image-available-2.jpg"
        if let posterPathSting = film?.posterPath {
            posterPathUrl = "https://image.tmdb.org/t/p/w500/" + posterPathSting
        }
        
        
        let data = try? Data(contentsOf: URL(string: posterPathUrl)! )
        
        if let imageData = data {
            destination.imageData = imageData
        }
        
        
        
        destination.text = film?.title ?? ""
            
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchProcess(searchText: searchText)
    }
}
