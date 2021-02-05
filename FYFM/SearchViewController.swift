//
//  SearchViewController.swift
//  FYFM
//
//  Created by Сергей on 07.12.2020.
//
import UIKit
public let apiKey = "e7d6c37e59198290cfb7b07ee39bec9f"
class SearchViewController: UIViewController,UIAlertViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    
    let networkDataFetcher = NetWorkDataFetcher()
    var filmsListResponse: FilmsListResponse? = nil
    var someIndex = Int()
    
    
    func alert(){
        let alertController = UIAlertController(title: "трабл", message: "хз шо за фильм", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок, я попробую поискать иначе", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
    private var timer: Timer? = nil
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    
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
                                        self.collectionView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.alert()
                    self.collectionView.reloadData()
                }
            }
        }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (self.collectionView != nil) {
            self.collectionView.reloadData()
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmsListResponse?.results.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.view.frame.size.width) / 3) - 1
            let height = (width * 1.5)+30
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

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
        let text:String =  self.searchBar.text?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil) ?? " "
        searchProcess(searchText: text)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(self.searchBar.text ?? "some text")
    }
}
