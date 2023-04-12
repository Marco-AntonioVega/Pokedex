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
    var idsWithNoCries: [Int] = [741, 745, 803, 804, 805, 806, 807, 808, 809, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 902, 903, 904, 905]
    var cryAudioURL: String = ""
    var chosenCry: Int = 0

    @IBOutlet weak var topLeftImage: UIImageView!
    @IBOutlet weak var topRightImage: UIImageView!
    @IBOutlet weak var bottomRightImage: UIImageView!
    @IBOutlet weak var bottomLeftImage: UIImageView!
    
    @IBAction func playCryButtonTapped(_ sender: Any) {
        let audioURL = URL(string: cryAudioURL)
        if let audioURL = audioURL {
            playAudio(from: audioURL)
        }
    }

    @IBAction func onPokemonTapped(_ gesture: UITapGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            // image view tags are from 1 to 4 from top left to bottom right, needed unique tags and all other elements have tag 0
            if imageView.tag == chosenCry + 1 {
                imageView.backgroundColor = .green
                
                // disable tap gestures
                view.viewWithTag(1)?.isUserInteractionEnabled = false
                view.viewWithTag(2)?.isUserInteractionEnabled = false
                view.viewWithTag(3)?.isUserInteractionEnabled = false
                view.viewWithTag(4)?.isUserInteractionEnabled = false
            } else {
                imageView.backgroundColor = .red
            }
        }
    }
    
    @IBAction func onNewQuizTapped(_ sender: Any) {
        loadNewQuiz()
    }
    
    func playAudio(from url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNewQuiz()
    }
    
    func loadNewQuiz() {
        // enable tap gestures
        view.viewWithTag(1)?.isUserInteractionEnabled = true
        view.viewWithTag(2)?.isUserInteractionEnabled = true
        view.viewWithTag(3)?.isUserInteractionEnabled = true
        view.viewWithTag(4)?.isUserInteractionEnabled = true
        
        var ids: [Int] = []
        var natDexNum: Int
        chosenCry = Int.random(in: 0...3)
        
        for _ in 1...4 {
            repeat {
                natDexNum = Int.random(in: 1..<(Utility.getMaxDexNum() + 1))
            }
            while idsWithNoCries.contains(natDexNum) && ids.contains(natDexNum)
            ids.append(natDexNum)
        }
        
        cryAudioURL = "https://pokemoncries.com/cries/\(ids[chosenCry]).mp3"
        
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(ids[0]).png")!, into: topLeftImage)
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(ids[1]).png")!, into: topRightImage)
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(ids[2]).png")!, into: bottomLeftImage)
        Nuke.loadImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(ids[3]).png")!, into: bottomRightImage)
        
        for i in 1...4 {
            view.viewWithTag(i)?.backgroundColor = .white
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
