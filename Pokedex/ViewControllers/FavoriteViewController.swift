//
//  FavoriteViewController.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/4/23.
//

import UIKit
import Nuke

class FavoriteViewController: UIViewController, UICollectionViewDataSource, RandomViewControllerDelegate {
    
    var favoritePokemonList: [PokemonFavoriteEntry] = []

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set this view as the delegate for ViewControllers that change favoriteEntrys
        if let tabBarControllers = tabBarController?.viewControllers {
            for viewController in tabBarControllers {
                if let navigationController = viewController as? UINavigationController,
                   let view2 = navigationController.viewControllers.first as? RandomViewController {
                    print("DELEGATE SET!")
                    view2.delegate = self
                    break
                }
            }
        }
        
        favoriteCollectionView.dataSource = self
        
        getFavoritePokemon()
        
        // spacing
        let layout = favoriteCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        let width = 128
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
    
    func getFavoritePokemon() {
        let queue = DispatchQueue.global(qos: .background)
        
        queue.async { [weak self] in
            let query = PokemonFavoriteEntry.query()
                .include("user")
            
            query.find { [weak self] result in
                switch result {
                case .success(let entries):
                    DispatchQueue.main.async {
                        self?.favoritePokemonList = entries
                        self?.favoriteCollectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCollectionViewCell
        
        let favoritePokemon = favoritePokemonList[indexPath.item]
        
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(favoritePokemon.pokemonID!).png")!, into: cell.favoritePokemonImageView)
        APIFunctions.getAllDetails(id: favoritePokemon.pokemonID!) {
            pokemonDetails in DispatchQueue.main.async {
                cell.favoritePokemonNameLabel.text = pokemonDetails?.name
            }
        }
        return cell
    }
    
    // called by other ViewControllers to update favorites list when favorited
    func didAddFavorite(item: PokemonFavoriteEntry) {
        favoritePokemonList.append(item)
        favoriteCollectionView.reloadData()
        
        // copy & paste where poke is favorited self?.delegate!.didAddFavorite(item: entry)
    }
    
    // called by other ViewControllers to update favorites list when unfavorited
    func removedFavorite(item: PokemonFavoriteEntry) {
        favoritePokemonList.removeAll(where: { $0 == item })
        favoriteCollectionView.reloadData()
        
        // copy & paste where poke is unfavorited self?.delegate!.removedFavorite(item: entry)
    }
    
    // Add to view controllers that will update favorites
//    protocol RandomViewControllerDelegate: AnyObject {
//        func didAddFavorite(item: PokemonFavoriteEntry)
//        func removedFavorite(item: PokemonFavoriteEntry)
//    }
}
