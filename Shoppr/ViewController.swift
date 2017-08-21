//
//  ViewController.swift
//  Shoppr
//
//  Created by Mohd Adam on 18/08/2017.
//  Copyright © 2017 Mohd Adam. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.layer.borderWidth = CGFloat(1.0)
        }
    }
    
    var newsImage: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getNewsID()
        
        let collectionViewLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
    }

    func getNewsID() {
        
        let urlSession = URLSession(configuration: .default)
        
        let url = URL(string: "http://developer.myntra.com/v2/search/data/men-jackets-nav?p=1&rows=48&userQuery=false")
        
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "GET"
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
            if let valideError = error {
                
                print(valideError.localizedDescription)
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            switch httpResponse.statusCode {
                
            case 200...299:
                
                if let validData = data {
                    
                    do {
                        
                        let json: [String:Any]? = try JSONSerialization.jsonObject(with: validData, options: .allowFragments) as? [String:Any]
                        
                        guard let getData = json?["data"] as? [String:Any] else { return }
                        
                        guard let getResult = getData["results"] as? [String:Any] else { return }
                        
                        guard let getProducts = getResult["products"] as? [[String:Any]] else { return }
                        
                        for retrievedObject in getProducts {
                            
                            if let latestImageURL = News(dictionary: retrievedObject) {
                                
                                latestImageURL.urlToImage = retrievedObject["search_image"] as? String

                                DispatchQueue.main.async {
                                    
                                    self.newsImage.append(latestImageURL)

                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.collectionView.reloadData()
                        }
                        
                        return
                    }
                    catch {
                        
                        return
                    }
                }
                
            case 400...599:
                return
            default:
                return
            }
            
            }.resume()
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsImage.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCell
        
        let currentRow = newsImage[indexPath.row]

        if let url = currentRow.urlToImage {
            
            let imageURL = URL(string: url)
            
            cell.imgCell.sd_setImage(with: imageURL)
        }

        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        
        // add the required height, if you want to fill the whole screen it should be 'screenSize.height / 2'
        return CGSize(width: screenSize.width / 2, height: screenSize.height / 2)
    }
}

