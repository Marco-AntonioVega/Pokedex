//
//  RandomViewController.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/4/23.
//

import UIKit
import AVFoundation
import Nuke

class RandomViewController: UIViewController {

    @IBOutlet weak var variants: UISegmentedControl!
    @IBOutlet weak var pokemon_Name: UILabel!
    @IBOutlet weak var pokemon_Image: UIImageView!
    @IBOutlet weak var flavor_text: UITextView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var species: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var abilities: UILabel!
    
    private var player: AVPlayer?
    var natDexNum: Int = 0
  
    func playAudio (from url: URL){
        player = AVPlayer (url: url)
        player?.play()
    }
    
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
      
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/144.png")
        pokemon_Name.text = String("Articuno #0144")
        
        Nuke.loadImage(with: url!, into: pokemon_Image)
        flavor_text.text = String("A legendary bird POKéMON that is said to appear to doomed people who are lost in icy mountains.")
        
        type.text = String("Psychic/Flying")
        species.text = String("Freeze POKéMON")
        height.text = String("1.7 m")
        weight.text = String("50.9 kg")
        abilities.text = String("Competitive")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    @IBAction func playCryOnTapped(_ sender: Any) {
        let audioURL = URL(string: "https://pokemoncries.com/cries/144.mp3")
        if let audioURL = audioURL{
            playAudio(from: audioURL)
        }
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
