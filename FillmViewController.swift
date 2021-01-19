//
//  FillmViewController.swift
//  FYFM
//
//  Created by Сергей on 22.12.2020.
//

import UIKit

class FillmViewController: UIViewController {
    
    @IBAction func closeButton(_ sender: Any) {
        self.presentingViewController!.dismiss(animated: true )
            print("cancel")
    }
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var mainPoster: UIImageView!
    @IBOutlet weak var overviewText: UILabel!
    var overview = String()
    var filmTitle = String()
    var imageData = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.text = filmTitle
        overviewText.text = overview
        mainPoster.image = UIImage(data: imageData)
    }
}
