//
//  SoundViewController.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/5/23.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    private var player: AVPlayer?

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

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
