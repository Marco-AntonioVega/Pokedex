//
//  RandomViewController.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/4/23.
//

import UIKit

class RandomViewController: UIViewController {
    
    var natDexNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        natDexNum = Int.random(in: 1..<(APIFunctions.getNationalDexCap() + 1))

        APIFunctions.getAllDetails(id: natDexNum) {
            pokemonAllDetails in DispatchQueue.main.async {
                if let pokemonAllDetails = pokemonAllDetails {
                    print(pokemonAllDetails.id!)
                    print(pokemonAllDetails.name!)
                    print(pokemonAllDetails.variants!)
                    print(pokemonAllDetails.cry!)
                    print(pokemonAllDetails.flavorText!)
                    print(pokemonAllDetails.genus!)
                }
            }
        }
        
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
}
