//
//  FavoriteDetailViewController.swift
//  Pokedex
//
//  Created by ungerardo on 4/15/23.
//

import UIKit
import AVFoundation
import Nuke

protocol FavoriteDetailViewControllerDelegate: AnyObject {
    func didAddFavorite(item: PokemonFavoriteEntry)
    func removedFavorite(item: PokemonFavoriteEntry)
}

class FavoriteDetailViewController: UIViewController {
    
    @IBOutlet weak var variants: UISegmentedControl!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonSprite: UIImageView!
    @IBOutlet weak var flavorText: UITextView!
    @IBOutlet weak var types: UILabel!
    @IBOutlet weak var species: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var abilities: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var pokemonID: Int?
    var cry: String = ""
    var variantArray: [Any] = []
    
    var delegate: FavoriteDetailViewControllerDelegate?
    private var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPokemon(natDexNum: pokemonID!, index: 0) { [weak self] in
            
            self?.variantArray = $0
            //print(self?.variantArray ?? [])
            self!.variants.isHidden = false
        }
    }
    
    private func loadPokemon(natDexNum: Int, index: Int, completion: @escaping ([Any]) -> Void) {
        
        var tempVariantArray: [Any] = []
        
        APIFunctions.getAllDetails(id: natDexNum) {
            pokemonAllDetails in DispatchQueue.main.async { [self] in
                if let pokemonAllDetails = pokemonAllDetails {
                    
                    //displays current Pokemon information
                    pokemonName.text = "\(pokemonAllDetails.name!) #\(Utility.pad(id: pokemonAllDetails.id!))"
                    
                    let arr = pokemonAllDetails.variants![index] as! PokemonVariantDetails
                    types.text = arr.types
                    height.text = Utility.getHeight(height: arr.height!)
                    weight.text = Utility.getWeight(weight: arr.weight!)
                    abilities.text = arr.abilities
                    
                    let url = URL(string: arr.sprite!)
                    Nuke.loadImage(with: url!, into: pokemonSprite)

                    species.text = pokemonAllDetails.genus
                    flavorText.text = pokemonAllDetails.flavorText
                    cry = pokemonAllDetails.cry!
                    
                    if(pokemonAllDetails.variants!.count > 1) {
                        
                        //fetches variant information if possible
                        for entry in pokemonAllDetails.variants! {
                            tempVariantArray.append(entry as! PokemonVariantDetails)
                            
                            //fills in variant names in tabs
                            if(self.variants.numberOfSegments < pokemonAllDetails.variants!.count || self.variants.titleForSegment(at: 1) == "Second") {
                                if let variantName = entry as? PokemonVariantDetails {

                                    if(self.variants.titleForSegment(at: 0) == "First") {
                                        self.variants.setTitle(variantName.name, forSegmentAt: 0)
                                    } else if(self.variants.titleForSegment(at: 1) == "Second") {
                                        self.variants.setTitle(variantName.name, forSegmentAt: 1)
                                    } else {
                                        self.variants.insertSegment(withTitle: variantName.name, at: self.variants.numberOfSegments, animated: false)
                                    }
                                }
                            }
                        }
                        self.variantArray = tempVariantArray
                        completion(variantArray)
                    }
                    
                    //hides segemented tab if no variants
                    else {
                        self.variants.isHidden = true
                    }
                }
            }
        }
    }
    
    //plays audio
    func playAudio (from url: URL){
        player = AVPlayer (url: url)
        player?.play()
    }
    
    //handles audio button being tapped
    @IBAction func playCryOnTapped(_ sender: Any) {
        let audioURL = URL(string: cry)
        if let audioURL = audioURL{
            playAudio(from: audioURL)
        }
    }

}
