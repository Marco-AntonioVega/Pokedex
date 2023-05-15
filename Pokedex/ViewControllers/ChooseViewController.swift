//
//  ChooseViewController.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/5/23.
//

import UIKit
import AVFoundation
import Nuke

protocol ChooseViewControllerDelegate: AnyObject {
    func didAddFavorite(item: PokemonFavoriteEntry)
    func removedFavorite(item: PokemonFavoriteEntry)
}

class ChooseViewController: UIViewController {

    @IBOutlet weak var variants: UISegmentedControl!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonSprite: UIImageView!
    @IBOutlet weak var types: UILabel!
    @IBOutlet weak var species: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var abilities: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var userInput: UITextField!
    
    //audio manager
    private var player: AVPlayer?
    
    var natDexNum: Int = 0
    let maxNatDexNum: Int = Utility.getMaxDexNum()
    var cry: String = ""
    var variantArray: [Any] = []
    
    var delegate: ChooseViewControllerDelegate?
    
    //sets default empty values
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/12ecb7ae-7059-48df-a4f8-2e3fb7858606/d47rmjf-de88a574-49c8-4dcf-9df4-7e11722e8bec.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwic3ViIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsImF1ZCI6WyJ1cm46c2VydmljZTpmaWxlLmRvd25sb2FkIl0sIm9iaiI6W1t7InBhdGgiOiIvZi8xMmVjYjdhZS03MDU5LTQ4ZGYtYTRmOC0yZTNmYjc4NTg2MDYvZDQ3cm1qZi1kZTg4YTU3NC00OWM4LTRkY2YtOWRmNC03ZTExNzIyZThiZWMucG5nIn1dXX0.qQtrPbihCWTTF7bQl9cQzUVnPw_yhtVNHAWcDgQV8k4")
        
        Nuke.loadImage(with: url!, into: pokemonSprite)
        
        userInput.keyboardType = .numberPad
        
        favoriteBtn.isHidden = true
        variants.isHidden = true
    }
    
    //handles changing Pokemon variant
    func triggerChangePokemon(index: Int) {
        
        loadPokemon(natDexNum: natDexNum, index: index) { [weak self] in
            
            self?.variantArray = $0
            self!.variants.isHidden = false
        }
    }
    
    //changes Pokemon if variant tab is tapped
    @IBAction func onSegmentTap(_ sender: UISegmentedControl) {
        triggerChangePokemon(index: variants.selectedSegmentIndex)
    }
    
    //gets Pokemon data from natDexNum and tab variant
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
    
    //changes favorite star and adds/removes favorites
    @IBAction func onFavoriteTapped(_ sender: UIButton) {

        if(favoriteBtn.currentImage == UIImage(systemName: "star")) {

            postFavorite()
            favoriteBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            Task {
                await removeFavorite()
            }
            favoriteBtn.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    //adds favorite to user account
    func postFavorite() {
        
        // Create PokemonFavoriteEntry object
        var entry = PokemonFavoriteEntry()

        // Set properties
        entry.pokemonID = natDexNum
        
        // Set the user as the current user
        entry.user = User.current

        // Save object in background (async)
        entry.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    print("✅ Pokemon Saved! \(entry)")
                    // used to refresh favorites list
                    self?.delegate!.didAddFavorite(item: entry)
                    
                    // Get the current user
                    if let currentUser = User.current {

                        // Save updates to the user (async)
                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Saved! \(user)")

                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
    
    //removes favorite from user account
    @available(iOS 15.0, *)
    func removeFavorite() async {
        let query = PokemonFavoriteEntry.query()
            .include("user")
            
        do {
            let entries = try await query.find()
            for entry in entries {
                if entry.pokemonID == self.natDexNum && entry.user == User.current {
                    do {
                        try await entry.delete()
                        // remove pokemon from Favorites list
                        delegate?.removedFavorite(item: entry)
                    } catch {
                        // Handle any errors that may occur during deletion
                        showAlert(description: error.localizedDescription)
                    }
                    return
                }
            }
        } catch {
            // Handle any errors that may occur during query execution
            showAlert(description: error.localizedDescription)
        }
    }
    
    //checks if current Pokemon is favorited by user
    func checkIsFavorite() {
        
        let query = PokemonFavoriteEntry.query()
            .include("user")
        // Fetch objects defined in query (async)
        query.find { [weak self] result in
            switch result {
            case .success(let entries):
                for entry in entries {
                    if(entry.pokemonID == self?.natDexNum && entry.user?.email == User.current?.email) {
                        self?.favoriteBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        return
                    }
                }
                
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
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
    
    //populates UI with user input Pokedex num
    @IBAction func onSubmitTapped(_ sender: UIButton) {
        
        //fetches Pokemon info if valid input
        if userInput.text == "" {
            return
        }
        
        if let num = Int(userInput.text ?? "") {
            if(num < 1 || num > 905) {
                showTryAgainAlert()
                return
            }
            
            natDexNum = num
            
        } else {
            showTryAgainAlert()
            return
        }
        
        favoriteBtn.isHidden = false
        
        //removes extra variants tabs over 2
        while(variants.numberOfSegments > 2) {
            variants.removeSegment(at: variants.numberOfSegments - 1, animated: false)
        }
        
        variants.setTitle("First", forSegmentAt: 0)
        variants.setTitle("Second", forSegmentAt: 1)
        
        triggerChangePokemon(index: 0)

        favoriteBtn.setImage(UIImage(systemName: "star"), for: .normal)
        checkIsFavorite()
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
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showTryAgainAlert() {
        let alertController = UIAlertController(title: "Please enter a valid input", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
