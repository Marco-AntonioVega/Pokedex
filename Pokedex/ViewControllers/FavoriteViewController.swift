//
//  FavoriteViewController.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/4/23.
//

import UIKit
import Nuke

class FavoriteViewController: UIViewController, UICollectionViewDataSource {
    var favoritePokemonList: [PokemonFavoriteEntry] = []

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteCollectionView.dataSource = self
        
        // after setting the favoritePokemonList, reloadData
        favoriteCollectionView.reloadData()
        
        // spacing
        let layout = favoriteCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        let numberOfColumns: CGFloat = 3
        let width = (favoriteCollectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfColumns - 1)) / numberOfColumns
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of \(User.current?.username ?? "current account")?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCollectionViewCell
        
        let favoritePokemon = favoritePokemonList[indexPath.item]
        
        let imageURL = favoritePokemon.image
        let pokemonName = favoritePokemon.name
        
        Nuke.loadImage(with: imageURL, into: cell.favoritePokemonImageView)
        
        return cell
    }
    

}
