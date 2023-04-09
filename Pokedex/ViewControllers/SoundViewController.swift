//
//  SoundViewController.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/5/23.
//

import UIKit
import AVFoundation
import Nuke

class SoundViewController: UIViewController {
    
    private var player: AVPlayer?

    @IBOutlet weak var topLeftImage: UIImageView!
    @IBOutlet weak var topRightImage: UIImageView!
    @IBOutlet weak var bottomRightImage: UIImageView!
    @IBOutlet weak var bottomLeftImage: UIImageView!
    
    @IBAction func playCryButtonTapped(_ sender: Any) {
        let audioURL = URL(string: "https://pokemoncries.com/cries/63.mp3")
        if let audioURL = audioURL {
            playAudio(from: audioURL)
        }
    }
    
    func playAudio(from url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/928.png")!, into: topLeftImage)
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/929.png")!, into: topRightImage)
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/930.png")!, into: bottomLeftImage)
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/931.png")!, into: bottomRightImage)
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
